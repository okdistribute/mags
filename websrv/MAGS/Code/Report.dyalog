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
⍝ The results are stored in the appropriate database row.
 Generate←{
     ⎕←'Generating report for ',⊃⍵
     probs←⊂[1]AssignmentProblems 1⊃⍵
     code←StudentCode ⍵
     rep←⎕XML(0 'grading-results' '' (0 2⍴''))⍪⊃⍪/(⊂code)MkRep¨probs
     ⍵ UpdateReport rep
 }
 
⍝ Generates an XML report using the grader
⍝    Right: name grader testsuite solution grader_params
⍝    Left:  code
⍝ If the running of the autograder command fails for some
⍝ reason, then we report that as a single failed test.
 MkRep←{
     name grader suite sol param←⍵
     res←1 4⍴1 'test-group' '' (1 2⍴'name' name)
     cmd←graders,⊃{⍺,' ',⍵}/grader suite sol ⍺ param
     fail_attrs←3 2⍴'name' 'Autograder Command' 'expected' 'pass' 'result' 'fail'
     11::res⍪1 4⍴2 'test-result' '' fail_attrs
     rep←1 ¯1↓⎕XML ⊃{⍺,(⎕UCS 10),⍵}/⎕SH cmd
     rep[;0]+←1
     res⍪ValidateXML rep
 }
 
⍝ Reports will not always be correct. The report may end up 
⍝ appearing like valid XML but not be valid in the slightest. 
⍝ To deal with this, there are a number of layers that we 
⍝ use to try to make sure that the output is correct. 
⍝ The first layer is in the shell command itself. If it fails, 
⍝ then we just deal with it right then. If the command itself
⍝ does not fail, however, then it is important for us to validate
⍝ the input from the shell command. The first validation occurs 
⍝ when we call ⎕XML on the result. This guarantees that we have, 
⍝ at the least, valid XML. Even with valid XML, however, it might 
⍝ not be the correct format that we expect. The following 
⍝ function predicate checks whether we have the right format
⍝ or not. It is meant to be called as the final step of MkRep.

 ValidateXML←{
    ⍝ 
    ⍝ If validation fails, we will return a failure test-result.
     fail_attrs←3 2⍴'name' 'Output validation' 'expected' 'pass' 'result' 'fail'
     fail←1 4⍴2 'test-result' '' fail_attrs
    ⍝
    ⍝ Verify that all of the nodes are of the correct type
     vnds←'test-group' 'test-result' 'test-property'
     ~∧/⍵[;1]∊vnds:fail
    ⍝
    ⍝ Make sure that the depths are all greater than 0
     ~∧/0<⍵[;0]:fail
    ⍝
    ⍝ Test-results and test-groups should not have any CDATA
     ~∧/(⊂'')≡¨(⍵[;1]∊2↑vnds)/⍵[;2]:fail 
    ⍝
    ⍝ There really should be a check here about the correct
    ⍝ hierarchy, but I just haven't had the time to do it. 
    ⍝ XXX
    ⍝
    ⍝ Everything seems to have worked
     ⍵
 }

:EndNamespace