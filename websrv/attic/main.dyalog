:Namespace Main

    ⎕IO←0

    ⍝ Init <dbdir> <port>
      Init←{
          dbdir port←⍵
          _←OpenDb dbdir
          _←#.SAWS.Init
          {}'#.WS'#.SAWS.Run port 1
      }

    ⍝ Stop
    ∇ Stop
      #.SAWS.Stop ⍬
      CloseDb
    ∇

    ⍝ OpenDb <dbdir>
      OpenDb←{
          dbdir←⍵
          open←{'w'#.ddb.open dbdir,⍵}
          build←{'#.DB.',⍵,'←open ''',⍵,''''}
          ⍎∘build¨#.DB.tables
      }

    ⍝ CloseDb
    ∇ CloseDb
      ⎕EX¨(⊂'#.DB.'),¨#.DB.tables
    ∇

    ⍝ AddInstructors N 3⍴(<networkid> <firstname> <lastname>) ...
      AddInstructors←{
          #.DB.Instructor #.ddb.append⊂[0]⍵
      }

    ⍝ GetInstructors <fields>
      GetInstructors←{
          1≠⍴⍴⍵:⎕SIGNAL 11
          flds←⊃(#.DB.Instructor.names ⍵)[0≠⍴⍵]
          ⍉↑#.DB.Instructor #.ddb.get flds
      }
      
    ⍝ ListComments
    ∇ R←ListComments
      R←⍪#.DB.Comment #.ddb.get'text'
    ∇
    
    ⍝ AddComments
      AddComments←{
          #.DB.Comment #.ddb.append ⍵
      }

:EndNamespace
