:Namespace Report

⍝ This namespace provides the means of generating grading reports for 
⍝ student submissions. 

 ⎕IO←0
 AssignmentProblems←#.Database.AssignmentProblems
 StudentCode←#.Database.StudentCode
 UpdateReport←#.Database.UpdateReport
 
 graders←'../graders/'
 
⍝ Grade a single submission given:
⍝   owner submittedfor date
 Generate←{
     probs←⊂[1]AssignmentProblems 1⊃⍵
     code←StudentCode ⍵
     rep←⎕XML(0 'grading-results' '' (0 2⍴''))⍪⊃⍪/(⊂code)MkRep¨probs
     ⍵ UpdateReport rep
 }
 
⍝ Generates an XML report using the grader
⍝    Right: name grader testsuite solution grader_params
⍝    Left:  code
 MkRep←{
     name grader suite sol param←⍵
     res←1 4⍴1 'test-group' '' (1 2⍴'name' name)
     cmd←graders,⊃{⍺,' ',⍵}/grader suite sol ⍺ param
     fail_attrs←3 2⍴'name' 'Autograder Command' 'expected' 'pass' 'result' 'fail'
     11::res⍪1 4⍴2 'test-result' '' fail_attrs
     rep←1 ¯1↓⎕XML ⊃{⍺,(⎕UCS 10),⍵}/⎕←⎕SH cmd
     rep[;0]+←1
     res⍪rep
 }

:EndNamespace