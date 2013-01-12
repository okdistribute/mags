:Namespace Database

 StudRepSQL←'SELECT report FROM submissions'
 StudRepSQL,←'WHERE submissionid = :<I:'

 StudSubSQL←'SELECT (submissionid, submittedfor, date) FROM submissions'
 StudSubSQL,←'WHERE owner = :<C50:'

 Do←{#.SQL.Do(⊂'MAGSDB'),⍵}

 StudentSubmissions←{
     50<⍴⍵: 0 0⍴''
     res dat cols←Do StudSubSQL ⍵
     0≠res:0 0⍴''
     dat
 }

 SubmissionReport←{
     res dat cols←Do StudRepSQL ⍵
     0≠res:0 0⍴''
     ⎕XML dat
 }

:EndNamespace
