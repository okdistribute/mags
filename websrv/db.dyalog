:Namespace DB

    ⎕IO←0
    
    tables←,⊂'Instructor'
    fields←,⊂(('networkid' 80 ¯10)('firstname' 80 ¯30)('lastname' 80 ¯30))
    tables,←'Group' 'Assignment'
    fields,←('name' 80 ¯30) ('name' 80 ¯10)
    tables,←⊂'Problem'
    fields,←⊂(('name' 80 ¯10)('description' 80 ¯2000)('testsuite' 80 ¯5000)('solution' 80 ¯5000))
    tables,←⊂'Submitter'
    fields,←⊂(('networkid' 80 ¯10)('firstname' 80 ¯30)('lastname' 80 ¯30)('member' 80 ¯30))
    tables,←⊂'Submission'
    fields,←⊂(('owner' 80 ¯10)('submittedfor' 80 ¯30)('date' 80 ¯8)('isappeal' 83)('code' 80 ¯5000)('reportxml' 80 ¯5000))
    tables,←'Category' 'Deadline'
    fields,←('name' 80 ¯30)(('type' 80 ¯10)('date' 80 ¯8))
    tables,←'Validator' 'Validates'
    fields,←(('name' 80 ¯10)('command' 80 ¯50))(('validator' 80 ¯10)('assignment' 80 ¯10)('params' 80 ¯100))
    tables,←'Teaches' 'HasType'
    fields,←(('teacher' 80 ¯10)('group' 80 ¯30))(('assignment' 80 ¯10)('category' 80 ¯30))
    tables,←⊂'HasDeadline'
    fields,←⊂('assignment' 80 ¯10)('type' 80 ¯10)('date' 80 ¯8)
    tables,←'BelongsTo' 'Contains'
    fields,←(('assignemnt' 80 ¯10)('group' 80 ¯30))(('assignment' 80 ¯10)('problem' 80 ¯10)('number' 80 ¯5))
    tables,←⊂'CollaboratedWith'
    fields,←⊂('submitter' 80 ¯10)('assignment' 80 ¯10)('submitdate' 80 ¯8)('collaborator' 80 ¯10)
    tables,←⊂'CommentsOn'
    fields,←⊂('comment' 80 ¯300)('submitter' 80 ¯10)('assignment' 80 ¯10)('submitdate' 80 ¯8)('problem' 80 ¯10)('start' 163)('end' 163)
    tables,←⊂'Comment'
    fields,←⊂,⊂'text' 80 ¯300
    
    ⍝ CreateDb <dbdir>
      CreateDb←{
          ((⊂⍵),¨tables)#.ddb.create¨fields
      }
      
      RemoveDb←{
          #.ddb.remove¨(⊂⍵),¨tables
      }

:EndNamespace