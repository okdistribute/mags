:Namespace Database
 ⎕IO←0
 
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
 ⍝⍝ General database functionality for MAGS                           ⍝⍝
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
 ⍝
 ⍝ This namespace contains the basic code for accessing and interfacing 
 ⍝ with the MAGS database. No page should have to do their own database
 ⍝ accesses. Instead, all of that work should be done through this 
 ⍝ namespace and its functions.
 ⍝ 
 ⍝ Notice that the index origin is zero. Take care when including this 
 ⍝ into some other page.
 ⍝ 
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
 
 ⍝ This is a version of Do that makes more sense for what we are doing.
 ⍝ Basically, it will signal an error if it encounters one, trying to 
 ⍝ use the error message that was given by the #.SQA.Do call if possible,
 ⍝ or the error message of the connection attempt.
 ⍝ 
 ⍝ The result will either be something with some values or something that 
 ⍝ never would have had any values to begin with, such as an INSERT.
 ⍝ In the case of something that was executed purely for its side effect, 
 ⍝ we try to return the empty matrix with shape 0 0. If we have something 
 ⍝ that is expected to have returned some kind of values (determined by 
 ⍝ the fact that the value is nested or does not have the empty shape)
 ⍝ we do the extraction here rather than forcing the calling function to 
 ⍝ do that.
 ⍝
 ⍝ Right arguments: SQL [bindvars]
 ⍝
 ⍝ Note: If you do not use any bind variables, you may have to enclose 
 ⍝ the sql statement.

 Do←{
     0≠⊃z←#.SQL.ConnectTo'MAGSDB':(2⊃z)⎕SIGNAL⊃z
     0≠⊃z←#.SQA.Do(1↓z),⍵:(⍕z[1 2])⎕SIGNAL⊃z
     0 0≡⍴2⊃z:2⊃z
     2 0⊃z
 }

 ⍝ The following compensates for systems without Unicode wide character 
 ⍝ support. Bind variables and the like need to go through these 
 ⍝ functions when they are sent to and received from the database if 
 ⍝ they have a 'text' type.

 toUTF8←{⎕UCS'UTF-8'⎕UCS ⍵}
 fromUTF8←{'UTF-8' ⎕UCS ⎕UCS ⍵}
 
 ⍝ These functions help to generate all of those <CNN(V) formats
 ⍝ MkBVS returns two nested vectors of the bind variable declarations
 ⍝ and the text converted to UTF-8 and suitable for passing to the 
 ⍝ Do function. The MkBV function just does the bind variable 
 ⍝ declaration generation. MkBV takes an optional prefix to 
 ⍝ catenate to the bound variable if desired, and MkBVS extends 
 ⍝ this to allow for one prefix per variables to bind.
 
 MkBV←{⍺←⊢ ⋄ ⍺,':<C',(⍕⍴⍵),'(V):'}
 MkBVS←{⍺←⊢ ⋄ (⍺ MkBV¨X)(X←toUTF8¨⍵)}

 ⍝ Some SQL syntax helpers, in particular to help when 
 ⍝ creating comma and other sort of separated entities.

 and←{⍺,' and ',⍵}
 com←{⍺,', ',⍵}
 sep←{⊃⍺⍺/⍵}
 
 ⍝ The following help to generate inserts without too much extra 
 ⍝ messy work in other places. They are expected to be used as
 ⍝ follows:
 ⍝  
 ⍝    INSERT INTO tbl VALUES bvs dat
 ⍝
 ⍝ where tbl is the string of the table and column into which 
 ⍝ one is inserting, and (bvs dat) is the appropriate combination 
 ⍝ of bind variable declaration and associated, pre-processed data.
 ⍝ This produces an SQL string followed by bind variable values 
 ⍝ that can be passed to Do.
 
 INSERT←{(⊂'INSERT ',(⊃⍵),';'),1⊃⍵}
 INTO←{tbl sql dat←⍵ ⋄ ('INTO ',tbl,' ',sql) dat}
 VALUES←{⍺ ('VALUES (',(com sep ⊃⍵),')')(1⊃⍵)}
 
 ⍝ The following does the same as the above INSERT helpers, 
 ⍝but for the selection queries. The general usage pattern is as
 ⍝ follows:
 ⍝ 
 ⍝   SELECT cols FROM tbl WHERE bvs dat 
 ⍝
 ⍝ Here bvs and dat are similar to those in insert, except 
 ⍝ that bvs is expected to be a preconstructed condition suitable 
 ⍝ for the WHERE clause of an sql query. The cols variable should 
 ⍝ be a character vector of the columns and tbl likewise is the 
 ⍝ character vector of the table specification. Both of these should
 ⍝ be in sql format.
 
 SELECT←{(⊂'SELECT ',(⊃⍵),';'),1⊃⍵}
 FROM←{(,/⍺' FROM '(⊃⍵)),1↓⍵}
 WHERE←{(⊃,/⍺ ' WHERE ' (and sep ⊃⍵))(1⊃⍵)}
 
 ⍝ The following is the analogous form for UPDATE and is expected 
 ⍝ to be used as follows:
 ⍝ 
 ⍝   UPDATE tbl SET assgns WHERE bvs dat
 ⍝
 ⍝ Here the assgns should be a single string of the assignments, 
 ⍝ and the dat should contain both the variables for the bvs and 
 ⍝ for any bind variables in the assgns string.
 
 UPDATE←{(⊂'UPDATE ',(⊃⍵),';'),1⊃⍵}
 SET←{(,/⍺' SET '(⊃⍵)),1↓⍵}
 
 ⍝ The following are the basic insertion functions for the various tables
 ⍝ in the system. See the documentation of the database schema for more
 ⍝ information about these tables and their relationships.
 
 InsertGroup←{Do INSERT INTO 'groups(name)' VALUES MkBVS⊂⍵}
 InsertAssignment←{Do INSERT INTO 'assignments(name)' VALUES MkBVS⊂⍵}
 InsertStudent←{Do INSERT INTO 'submitters(networkid, firstname, lastname)' VALUES MkBVS ⍵}
 InsertProblem←{Do INSERT INTO 'problems(name,testsuite,solution,description,grader,grader_params)' VALUES MkBVS ⍵}
 InsertContains←{Do INSERT INTO 'contains(assignment, problem, number)' VALUES MkBVS ⍵}
 InsertMemberOf←{Do INSERT INTO 'memberof(group_name, student)' VALUES MkBVS ⍵}
 InsertBelongsTo←{Do INSERT INTO 'belongsto(group_name, assignment)' VALUES MkBVS ⍵}
 
 ⍝ The following are the more complex queries that we will be using to 
 ⍝ find the various pieces of information. most of them are pretty 
 ⍝ straightforward, but it is difficult to make them as regular 
 ⍝ as the insertion functions above.
 
 ⍝ Right Argument: Simple character vector of the student networkid
 StudentSubmissions←{
     fromUTF8¨Do SELECT 'submittedfor, date' FROM 'submissions' WHERE (⊂'owner = ')MkBVS⊂⍵
 }

 ⍝ Right Argument: owner, assignment, date
 SubmissionReport←{
     bvs dat←('owner' 'submittedfor',¨⊂' = ')MkBVS 2↑⍵
     bvs,←⊂'date = :<S:' ⋄ dat,←2↓⍵
     res←Do SELECT 'report' FROM 'submissions' WHERE bvs dat
     ⎕XML fromUTF8 ⊃res⍪' '
 }
 
 ⍝ Right argument: networkid of student
 StudentAssignments←{
     bvs dat←(⊂'memberof.student = ')MkBVS ⊂⍵
     bvs,←⊂'belongsto.group_name = memberof.group_name'
     fromUTF8¨Do SELECT 'assignment' FROM 'belongsto, memberof' WHERE bvs dat 
 }
 
 ⍝ RightArgument: assignment name
 AssignmentProblems←{
     bvs dat←(⊂'contains.assignment = ')MkBVS⊂⍵
     bvs,←⊂'contains.problem = problems.name'
     flds←'name,grader,testsuite,solution,grader_params'
     tbls←'problems,contains'
     fromUTF8¨Do SELECT flds FROM tbls WHERE bvs dat 
 }
 
 ⍝ The following function is for updating the value of the report column 
 ⍝ for a submission. Normally submissions will not be given a report when
 ⍝ they are first submitted, but will be graded at a later date. Thus,
 ⍝ we leave the report field empty until we fill it in with something like 
 ⍝ this. The right argument is the XML for the report, and the left argument
 ⍝ is the natural key of the submission to update with the xml.
 
 UpdateReport←{
     bvs dat←('owner' 'submittedfor',¨⊂' = ')MkBVS 2↑⍺
     bvs,←⊂'date = :<S:' ⋄ dat,←2↓⍺
     sbv←⊃⊃sbv val←(⊂'report = ')MkBVS ⊂⍵
     Do UPDATE 'submissions' SET sbv WHERE bvs(val,dat)
 }
 
:EndNamespace
