:Class index : MildPage

 ⎕IO←0

:Include #.HTMLInput

:Field Public casticket←''

 HTTPGet←#.HTTPClient.HTTPGet
 
 CASRedirectURL←'https://cas.iu.edu/cas/login?cassvc=IU&casurl='
 CASRedirectURL,←'http://localhost:8080/'
 CASValidateURL←'https://cas.iu.edu/cas/validate?cassvc=IU&'
 CASValidateURL,←'casurl=http://localhost:8080/&'
 CASValidateURL,←'casticket='

∇Render req;res;usr;grp
 :Access Public
 →(⊃res usr grp←CASValidate req)/0
 req.Return'p'Enclose'Validated ',usr,' in group ',grp,'.'
∇

 CASValidate←{
     casticket≡'':CASRedirect ⍵
     res←HTTPGet CASValidateURL,casticket
     ⎕THIS.casticket←''
     0≠⊃res:1 '' ''⊣⍵.Return'p'Enclose'An error occurred.'
     dat←2⊃res
     'yes'≡3↑dat:0 (¯1↓4↓dat) ''
     CASRedirect ⍵
 }

∇r←CASRedirect req
 req.Meta'http-equiv="refresh" content=0;"',CASRedirectURL,'"'
 r←1 '' ''
∇


:EndClass
