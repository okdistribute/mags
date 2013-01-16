:Class index : MildPage

⍝ This is the primary page for viewing the results of auto-grading.
⍝ In particular, after authentication, instructors and students 
⍝ should see a listing of the various assignments to which they 
⍝ have access and can select their grading results. Results are 
⍝ presented on a per assignment submission basis.

⍝ The following are some of the functions that we use a lot 
⍝ here. We have to be careful about importning HTMLInput
⍝ and make sure to use index origin 1 since the HTMLInput 
⍝ code requires ⎕IO≡1.

 ⎕IO←1

:Include #.HTMLInput

 HTTPGet←#.HTTPClient.HTTPGet

⍝ There is one main field that we care to know about during submission.
⍝ This field supports the Indiana University CAS authentication 
⍝ protocol. It contains a special validation string to identify 
⍝the user of the system if they have appropriately authenticated 
⍝ to the CAS system.

:Field Public casticket←''

⍝ There are three main CASE urls that facilitate the authentication 
⍝ process. Firstly, the main redirect URL is the one to which we redirect 
⍝ an unauthenticated user in order that they might authenticate 
⍝ themselves. Second is the URL that we use to validate a CAS ticket 
⍝ that we receive, to determine whether an user has successfully 
⍝ validated themselves. Finally, there is the URL to which we direct 
⍝ an user who wishes to logout. This logout is not necessarily secure, 
⍝ and closing the browser is the only sure way to truly logout.

 CASRedirectURL←'https://cas.iu.edu/cas/login?cassvc=IU&casurl='
 CASRedirectURL,←'http://localhost:8080/'
 CASValidateURL←'https://cas.iu.edu/cas/validate?cassvc=IU&'
 CASValidateURL,←'casurl=http://localhost:8080/&'
 CASValidateURL,←'casticket='
 CASLogoutURL←'https://cas.iu.edu/cas/logout'

⍝ If we receive a non-empty value in the casticket field, this means 
⍝ that an user is trying to authenticate using that validation token.
⍝ Presumably this token is the token that the CAS system assigned to 
⍝ the user after providing authentication credentials to the CAS 
⍝ login page. A CAS ticket is a one time token that we can use to 
⍝ ask the CAS system whether the connecting user really did authenticate 
⍝ and what their username is. The CASValidate function takes an
⍝HTTPRequest and validates the user, returning a vector of the 
⍝ result and the username. The result is zero if the validation 
⍝ succeeded, and the username will be a normal value. If the validation
⍝ did not succeed, we setup a redirect to point the user to the login
⍝ page to give them the opportunity to authenticate. In this case, 
⍝ we return 1 as our result.
 
 CASValidate←{
     casticket≡'':CASRedirect ⍵
     res←HTTPGet CASValidateURL,casticket
     ⎕THIS.casticket←''
     0≠⊃res:1 ''⊣⍵.Return'p'Enclose'An error occurred.'
     dat←3⊃res
     'yes'≡3↑dat:0 (¯2↓5↓dat)
     CASRedirect ⍵
 }
 
∇r←CASRedirect req
 req.Meta'http-equiv="refresh" content=0;"',CASRedirectURL,'"'
 r←1 ''
∇

⍝ The main page can be divided up into the rendering of four 
⍝ major components or areas. The main header at the top,
⍝ the assignments navigation bar, the main content, and 
⍝ the information panel, which contains the login information,
⍝ a logout link, and so forth. We have functions for rendering 
⍝ the assignments panel, the information panel, and the 
⍝ main content panel. The header is simple enough to include
⍝ inline. Our Render method thus looks pretty simple. We 
⍝ need to do any validation first, and if the validation 
⍝ succeeds, then we render the main page. 
 
∇Render req;res;usr;grp;bod;tmp
 :Access Public
 →(⊃res usr←CASValidate req)/0
 bod←'h1'Enclose'MAGS: McKelvey Auto-Grading System'
 bod,←RenderInfo usr
 bod,←RenderAssignments usr
 bod,←RenderContent usr
 req.Return bod
 req.Title 'MAGS: McKelvey Auto-Grading System'
 req.Style 'index.css'
∇

⍝ The information that we render in the information panel is 
⍝ simply the username of the viewer and a logout link.

 RenderInfo←{
     z←BRA'Logged in as ',⍵,'.'
     z,←'href' CASLogoutURL #.HTML.a 'Logout'
     'div id="info"'Enclose z
 }
 
⍝ We want to render a nested list of the assignments and the  
⍝ submissions for each assignment made by the student. 
⍝ We additionally want to put a submission button for each 
⍝ assignment somewhere.

 RenderAssignments←{
     asn←#.Database.StudentAssignments ⍵
     suba subd←⊂[1]#.Database.StudentSubmissions ⍵
     s4a←suba∘∊
     'assignments'List{⍵,List((s4a⊂⍵)/subd),⊂'Submit New'}¨asn
 }
 
⍝ Rendering the content will depend on whether we have anything 
⍝ interesting to put in the middle or not. By default we should 
⍝ display the latest assignment (by date) that has been submitted.
⍝ Otherwise, we should display the content that the user requests.
⍝ Right now are just putting in some sample results, without 
⍝ doing anything dynamic.
 
 RenderContent←{
     xml←⍉⎕XML ReadFile './sample_results.xml'
     grpbv←1=1⌷xml ⋄ attrs←4⌷xml
     z←'table'Enclose⊃,/(grpbv/attrs)RenderTestGroup¨1↓¨grpbv⊂attrs
     'div id="content"'Enclose z
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

⍝This is a simple functin to read in a UTF-8 file.
 
 ReadFile←{
     0::⎕SIGNAL ⎕EN
     tie←⍵ ⎕NTIE 0
     ints←⎕NREAD tie 83,⎕NSIZE tie
     'UTF-8' ⎕UCS ints
 }
 

:EndClass
