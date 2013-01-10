:Class index : MildPage

:Include #.HTMLInput

:Field Public casticket←''

 HTTPGet←#.HTTPClient.HTTPGet
 
 CASRedirectURL←'https://cas.iu.edu/cas/login?cassvc=IU&casurl='
 CASRedirectURL,←'http://localhost:8080/'
 CASValidateURL←'https://cas.iu.edu/cas/validate?cassvc=IU&'
 CASValidateURL,←'casurl=http://localhost:8080/&'
 CASValidateURL,←'casticket='

∇Render req;res;usr;grp;bod
 :Access Public
 →(⊃res usr grp←CASValidate req)/0
 bod←'h1'Enclose'MAGS: McKelvey Auto-Grading System'
 bod,←'div id="info"'Enclose'Logged in as ',usr,'.'
 bod,←'assignments'List⊂'Assignments go here'
 bod,←'div id="content"'Enclose'Content will go here.'
 req.Return bod
 req.Title 'MAGS: McKelvey Auto-Grading System'
 req.Style 'index.css'
∇

 CASValidate←{
     casticket≡'':CASRedirect ⍵
     res←HTTPGet CASValidateURL,casticket
     ⎕THIS.casticket←''
     0≠⊃res:1 '' ''⊣⍵.Return'p'Enclose'An error occurred.'
     dat←3⊃res
     'yes'≡3↑dat:0 (¯1↓4↓dat) ''
     CASRedirect ⍵
 }

∇r←CASRedirect req
 req.Meta'http-equiv="refresh" content=0;"',CASRedirectURL,'"'
 r←1 '' ''
∇


:EndClass
