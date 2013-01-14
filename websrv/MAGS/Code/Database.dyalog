:Namespace Database
 ⎕IO←0

 StudRepSQL←'SELECT report FROM submissions '
 StudRepSQL,←'WHERE '

 StudSubSQL←'SELECT (submittedfor, date) FROM submissions '
 StudSubSQL,←'WHERE owner = '

 InsGrpSQL←'INSERT INTO groups(name) VALUES ('

 InsStudSQL←'INSERT INTO submitters(networkid, firstname, lastname) '
 InsStudSQL,←'VALUES ('

 InsAssgnSQL←'INSERT INTO assignments(name) VALUES ('

 InsProbSQL←'INSERT INTO '
 InsProbSQL,←'problems(name, testsuite, solution, '
 InsProbSQL,←'description, grader, grader_params) '
 InsProbSQL,←'VALUES ('
 
 InsContainsSQL←'INSERT INTO '
 InsContainsSQL,←'contains(assignment, problem, number) '
 InsContainsSQL,←'VALUES ('
 
 InsMemOfSQL←'INSERT INTO '
 InsMemOfSQL,←'memberof("group", student) '
 InsMemOfSQL,←'VALUES ('
 
 InsBelToSQL←'INSERT INTO belongsto("group", assignment) VALUES ('
 
 StudAssgnSQL←'SELECT assignment FROM belongsto, memberof '
 StudAssgnSQL,←'WHERE belongsto.group = memberof.group '
 StudAssgnSQL,←'  and memberof.student = '

 Do←{0≠⊃z←#.SQL.ConnectTo'MAGSDB':4↑z ⋄ (#.SQA.Close 1⊃z)⊢4↑#.SQA.Do(1↓z),⍵}

 ⍝ Right Argument: Simple character vector of the student networkid
 StudentSubmissions←{
     bvs dat←MkBVS ⊂⍵
     res←Do(StudSubSQL,⊃bvs)(⊃dat)
     0≠⊃res:0 2⍴⊂''
     fromUTF8¨2 0⊃res
 }

 ⍝ Right Argument: owner, assignment, date
 SubmissionReport←{
     bvs dat←MkBVS 2↑⍵
     qs←StudRepSQL,⊃,/'owner' 'submittedfor'{⍺,' = ',⍵,' and '}¨bvs
     qs,←'date = :<S:'
     0≠⊃res←Do(⊂qs),dat,2↓⍵:⎕XML ''
     0=⊃⍴2 0⊃res:⎕XML ''
     ⎕XML fromUTF8 2 0 (0 0)⊃res
 }
 
 StudentAssignments←{
     bvs dat←MkBVS ⊂⍵
     res←Do(StudAssgnSQL,⊃bvs)(⊃dat)
     0≠⊃res:0 1⍴⊂''
     fromUTF8¨2 0⊃res
 }

 ⍝ Right Argument: Simple character vector of the group name
 InsertGroup←{
     bvs dat←MkBVS ⊂⍵
     ⊃Do (InsGrpSQL,(⊃bvs),');')(⊃dat)
 }

 ⍝ Right Argument: Simple character vector of the assignment name
 InsertAssignment←{
     bvs dat←MkBVS ⊂⍵
     ⊃Do (InsAssgnSQL,(⊃bvs),');')(⊃dat)
 }

 ⍝ Right Argument: Nested character vector of 
 ⍝     network id
 ⍝     first name
 ⍝     last name
 InsertStudent←{
     bvs dat←MkBVS ⍵
     ⊃Do (⊂InsStudSQL,(⊃{⍺,', ',⍵}/bvs),');'),dat
 }

 ⍝ Right Argument: Nested vector of
 ⍝     Name of the problem
 ⍝     Test Suite
 ⍝     Solution
 ⍝     Description
 ⍝     Grader
 ⍝     Grader Parameter
 InsertProblem←{
     bvs dat←MkBVS ⍵
     ⊃Do(⊂InsProbSQL,(⊃{⍺,', ',⍵}/bvs),');'),dat
 }
 
 ⍝ Right Argument: Nested vector of
 ⍝     Name of the Assignment
 ⍝     Name of the Problem
 ⍝     Text of the problem number
 InsertContains←{
     bvs dat←MkBVS ⍵
     ⊃Do(⊂InsContainsSQL,(⊃{⍺,', ',⍵}/bvs),');'),dat
 }
 
 ⍝ Right Argument: Nested Vector of
 ⍝     Name of group
 ⍝     Name of student (networkid)
 InsertMemberOf←{
     bvs dat←MkBVS ⍵
     ⊃Do(⊂InsMemOfSQL,(⊃{⍺,', ',⍵}/bvs),');'),dat
 }
 
 ⍝ Right Argument: Nested vector of
 ⍝     Name of group
 ⍝     Name of assignemtn
 InsertBelongsTo←{
      bvs dat←MkBVS ⍵
      ⊃Do(⊂InsBelToSQL,(⊃{⍺,', ',⍵}/bvs),');'),dat
 }
 
 ⍝ The following compensates for systems without Unicode wide character support
 toUTF8←{⎕UCS'UTF-8'⎕UCS ⍵}
 fromUTF8←{'UTF-8' ⎕UCS ⎕UCS ⍵}

 ⍝ This function helps to generate all of those <CNN(V) formats
 MkBVS←{({':<C',(⍕⍴⍵),'(V):'}¨X)(X←toUTF8¨⍵)}

:EndNamespace
