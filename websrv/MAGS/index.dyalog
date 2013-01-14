:Class index : MildPage

:Include #.HTMLInput

:Field Public casticket←''

 HTTPGet←#.HTTPClient.HTTPGet
 
 CASRedirectURL←'https://cas.iu.edu/cas/login?cassvc=IU&casurl='
 CASRedirectURL,←'http://localhost:8080/'
 CASValidateURL←'https://cas.iu.edu/cas/validate?cassvc=IU&'
 CASValidateURL,←'casurl=http://localhost:8080/&'
 CASValidateURL,←'casticket='

∇Render req;res;usr;grp;bod;tmp
 :Access Public
 →(⊃res usr grp←CASValidate req)/0
 bod←'h1'Enclose'MAGS: McKelvey Auto-Grading System'
 tmp←BRA'Logged in as ',usr,'.'
 tmp,←'href' 'https://cas.iu.edu/cas/logout'#.HTML.a 'Logout'
 bod,←'div id="info"'Enclose tmp
 bod,←'assignments'List RenderAssignments usr
 bod,←'div id="content"'Enclose RenderContent ''
 req.Return bod
 req.Title 'MAGS: McKelvey Auto-Grading System'
 req.Style 'index.css'
 ⎕←⍴#.Database.StudentSubmissions 'awhsu'
∇

 RenderAssignments←{
     ⊂'Assignments go here'
 }
 
 ReadFile←{
     0::⎕SIGNAL ⎕EN
     tie←⍵ ⎕NTIE 0
     ints←⎕NREAD tie 83,⎕NSIZE tie
     'UTF-8' ⎕UCS ints
 }
 
 RenderContent←{
     xml←⍉⎕XML ReadFile './sample_results.xml'
     grpbv←1=1⌷xml ⋄ attrs←4⌷xml
     'table'Enclose⊃,/(grpbv/attrs)RenderTestGroup¨1↓¨grpbv⊂attrs
 }
 
 RenderTestGroup←{
     res←'tr'Enclose'th colspan="3"'Enclose⊃(2,⍺[;1]⍳⊂'name')⌷⍉⍺
     res,⊃,/RenderTestResult¨⍵
 }
 
 RenderTestResult←{
     nam exp act←2('name' 'expected' 'result'⍳⍨1⌷⍉⍵)⌷(⍉⍵)
     cols←⊃,/(⊂'td')Enclose¨exp act
     exp≢act:'tr' Enclose ('td class="test_failed"' Enclose nam),cols
     'tr' Enclose ('td class="test_passed"' Enclose nam),cols
 }

 CASValidate←{
     casticket≡'':CASRedirect ⍵
     res←HTTPGet CASValidateURL,casticket
     ⎕THIS.casticket←''
     0≠⊃res:1 '' ''⊣⍵.Return'p'Enclose'An error occurred.'
     dat←3⊃res
     'yes'≡3↑dat:0 (¯2↓5↓dat) ''
     CASRedirect ⍵
 }

∇r←CASRedirect req
 req.Meta'http-equiv="refresh" content=0;"',CASRedirectURL,'"'
 r←1 '' ''
∇


:EndClass
