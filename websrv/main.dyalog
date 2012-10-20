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
          ⊢#.DB.Instructor←'w'#.ddb.open ⍵,'instructor'
      }

    ⍝ CloseDb
    ∇ CloseDb
      ⎕EX'#.DB.Instructor'
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

:EndNamespace