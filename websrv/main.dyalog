:Namespace Main

    ⎕IO←0
    
    ⍝ Init <dbdir> <port>
      Init←{
          dbdir port←⍵
          _←OpenDb dbdir
          _←#.SAWS.Init
          {}'#.WS'#.SAWS.Run port 1
      }
    
    ⍝ OpenDb <dbdir>
      OpenDb←{
          #.DB.Instructor←'w'#.ddb.open ⍵,'instructor'
      }
      
    ⍝ CloseDb
    ∇ CloseDb
      ⎕EX'#.DB.Instructor'
    ∇
    
    ⍝ AddInstructors N 3⍴(<networkid> <firstname> <lastname>) ...
      AddInstructors←{
          #.DB.Instructor #.ddb.append⊂[0]⍵
      }
    
    ⍝ <type> GetInstructors <pattern>
      GetInstructors←{
          ⍺←''
          0=⍴⍺:GetInstructorsByNetworkId ⍵
          'firstname'≡⍺:GetInstructorsByFirstName ⍵
          'lastname'≡⍺:GetInstructorsByLastName ⍵
          'UNRECOGNIZED TYPE'⎕SIGNAL 11
      }
      
    ⍝ GetInstructorsByNetworkId <networkid>
      GetInstructorsByNetworkId←{
          ⍉↑#.DB.Instructor #.ddb.get #.DB.Instructor.names
      }

:EndNamespace