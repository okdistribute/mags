:Class Logger : Lumberjack
⍝ MiServer HTTP Request Logger

⍝∇:require =/Lumberjack


    ⎕ML←1

    missing←{0∊⍴⍵:'-' ⋄ ⍵}

    ∇ Make ms;file;log;directory
      :Access public
      :Implements Constructor :Base
     
      ('MiServer Logger configuration file "',file,'" not found')⎕SIGNAL 11/⍨~#.Files.Exists file←ms.Root,'Config/Logger.xml'
     
      :If ~0∊⍴log←(#.XML.ToNS #.Files.GetText file).Logger
          Prefix←log #.Boot.Setting'prefix' 0 ''
          Interval←log #.Boot.Setting'interval' 1 10
          directory←#.Boot.SubstPath log #.Boot.Setting'directory' 0 ''
          Directory←{⍵,(~'/\'∊⍨¯1↑⍵)/'/'}directory
          Active←log #.Boot.Setting'active' 1 0
      :Else
          ('Invalid MiServer Logger configuration file "',file,'"')⎕SIGNAL 11
      :EndIf
    ∇

    ∇ Log req
      :Access public
      ⎕BASE.Log((missing 2⊃req.PeerAddr),' ',(missing req.Session.User),#.Dates.LogFmtNow,'"',req.Command,' ',req.Page,'"',∊' '∘,∘⍕¨req.(Response.Status MSec Response.Bytes)),EOL
    ∇

:EndClass