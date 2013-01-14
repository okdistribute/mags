:Namespace Database
 ⎕IO←0

 StudRepSQL←'SELECT report FROM submissions '
 StudRepSQL,←'WHERE '

 StudSubSQL←'SELECT (submittedfor, date) FROM submissions '
 StudSubSQL,←'WHERE owner = '

 InsGrpSQL←'INSERT INTO groups(name) VALUES ('

 InsStudSQL←'INSERT INTO submitters(networkid, firstname, lastname, memberof) '
 InsStudSQL,←'VALUES ('

 InsAssgnSQL←'INSERT INTO assignments(name) VALUES ('

 InsProbSQL←'INSERT INTO '
 InsProbSQL,←'problems(name, testsuite, solution, '
 InsProbSQL,←'description, grader, grader_params) '
 InsProbSQL,←'VALUES ('

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
 ⍝     group name of which the student is a member
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

 ⍝ The following compensates for systems without Unicode wide character support
 toUTF8←{⎕UCS'UTF-8'⎕UCS ⍵}
 fromUTF8←{'UTF-8' ⎕UCS ⎕UCS ⍵}

 ⍝ This function helps to generate all of those <CNN(V) formats
 MkBVS←{({':<C',(⍕⍴⍵),'(V):'}¨X)(X←toUTF8¨⍵)}

:EndNamespace
