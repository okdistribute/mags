:Namespace DB

    ⎕IO←0
    
    Tables←,⊂'instructor'
    Fields←,⊂(('networkid' 80 ¯10)('firstname' 80 ¯30)('lastname' 80 ¯30))
    
    ⍝ CreateDb <dbdir>
      CreateDb←{
          ((⊂⍵),¨Tables)#.ddb.create¨Fields
      }

:EndNamespace