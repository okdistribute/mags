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
⍝ to the CAS system. The other three fields correspond to the natural
⍝ key of a submission, which, if given, indicate the submission
⍝ that is to be displayed to the user, if the proper authentication 
⍝ is available.

:Field Public casticket←''
:Field Public submittedfor←''
:Field Public owner←''
:Field Public date←''

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
     inst←InstAssignments ⍵
     stud←StudAssignments ⍵
     'div id="assignments"' Enclose inst,stud
 }
 
⍝ The {Inst,Stud}Assignments functions achieve basically 
⍝ the same thing but with different expectations. 
⍝ The InstAssignments function renders the assignments 
⍝ that the username given has access to as a teacher or 
⍝ instructor, while the StudAssignments function does the 
⍝ same treating the user given as a student instead of 
⍝ an instructor. 
⍝
⍝ Both of these functions return a rendered HTML snippet.
⍝ These functions return list nodes, where the depth of 
⍝ the instructor list is three, while the listing depth of the 
⍝ student is only two. The first depth is the list of assignments, 
⍝and for the student assignments the second depth is the 
⍝ submission date. For the instructor assignments the second 
⍝ depth is the student, while the third depth is the submision 
⍝ date. 
⍝ 
⍝ Each submission listed as a leaf node in this tree should 
⍝ be a link to show the submission's grading report. This means 
⍝ that it needs to pass the owner, date, and assignment information
⍝ as url parameters to this page. The student listing should include
⍝ an extra link for submitting a new submission to a given assignment.

 InstAssignments←{
    ⍝ We query the data first, which comes in the form of a matrix, 
    ⍝ and then we return a blank vector if there is nothing to 
    ⍝ work with. 
     dat←#.Database.InstructorSubmissions ⍵
     0=⊃⍴dat:''
    ⍝ 
    ⍝ GrpBy takes in the matrix of query results 
    ⍝ and groups these results based on a particular
    ⍝ row. The row is given as the left argument, while
    ⍝ the matrix is the right argument. The result is a vector
    ⍝ of 2-vectors where the 1⊃ element is the character vector 
    ⍝ of the unique item under which these elemeents are grouped
    ⍝ and the 2⊃ element is the matrix of these elements.
     GrpBy←{(⊂¨bv/dr),∘⊂¨(bv←1,2≢/dr←⍺⌷⍉d)⊂[1]d←⍵[⍋↑⍺⌷⍉⍵;]}
    ⍝
    ⍝ The Mk_ functions create the list elements either for the 
    ⍝ set user links or the assignment grouping, depending on what 
    ⍝ they are given. Each expects to receive the group name as the 
    ⍝ left argument and the data in matrix form as the right argument.
     MkUsr←{⍺,List MkSubmissionLink¨⊂[2]⍵}
     MkAssgn←{⍺,List MkUsr/↑2 GrpBy ⍵}
    ⍝
    ⍝ Finally, we put a little header at the top of the top-level list 
    ⍝ node. We start with grouping by the first column, which is the 
    ⍝submission name, and MkAssgn groups by the second column, which 
    ⍝ is the networkid or owner column.
     ('h3' Enclose 'Instructor'),List MkAssgn/↑1 GrpBy dat
 }
 
 StudAssignments←{
     ''
 }
 
⍝ The following function helps to render the submission link
⍝ given the owner, assignment, and date. It takes the depth 
⍝ as the left argument and the owner, assignment, and date 
⍝ as the right argument.

 MkSubmissionLink←{
      ⍺←0 ⋄ href←⊃,/'?submittedfor=' '&owner=' '&date=',¨⍵
      'href' href #.HTML.a ⊃⌽⍵
 }
 
⍝ Rendering the content will depend on whether we have anything 
⍝ interesting to put in the middle or not. By default we should 
⍝ display the latest assignment (by date) that has been submitted.
⍝ Otherwise, we should display the content that the user requests.
⍝ We create a nested list of the test results, where each group
⍝ creates another level of nesting in the unordered list.

RenderContent←{
   ⍝ Right now we are just reading in a sample result file
     xml←⎕XML ReadFile './sample_results.xml'
   ⍝ 
   ⍝ getidx allows us to pass a character vector of a node 
   ⍝ name and get the indices of all those nodex in the 
   ⍝ tree.
     getidx←(/∘(⍳⊃⍴xml))∘(xml[;2]∘∊∘⊂)
   ⍝
   ⍝ We care about three distinct nodes, the groups, the results, 
   ⍝ and the properties.
     gi ri pi←getidx¨'test-group' 'test-result' 'test-property'
   ⍝
   ⍝ To transform the xml into the HTML result, we have to know 
   ⍝ how to shift the rows to accomodate the new nodes (ul) for
   ⍝ indicating the nesting in HTML. The basic rule is that 
   ⍝ each group now takes up two rows for its two nodes used to 
   ⍝ represent it, so we shift by one each time we encounter a 
   ⍝ group.
     sgi sri spi←+⌿¨(⊂gi)∘.<¨gi ri pi
   ⍝  
   ⍝ Then we can compute the new node indices of the resulting 
   ⍝ HTML based on the above shift values.
     ngi nri npi←gi ri pi+sgi sri spi
   ⍝
   ⍝ Right now we are creating a result only out of the results 
   ⍝ and the groups, ignoring the properties, so we create an 
   ⍝ empty XML tree to handle the right number of nodes that we
   ⍝ know will be in there, two for each group, and one for 
   ⍝ each result.
     res←(⊃1+(2×⍴gi)+⍴ri)4⍴0 '' '' (0 2⍴'')
   ⍝
   ⍝ All groups and result nodes will turn into li nodes
     res[ngi,nri;2]←⊂'li'
   ⍝
   ⍝ These two functions help us extract the name and 
   ⍝ whether or not the test was passed when given an attribute 
   ⍝ matrix.
     getname←{⊃(⍵[;1]∊⊂'name')/⍵[;2]}
     getpass←{⊃≡/(⍵[;1]∊'result' 'expected')/⍵[;2]}
   ⍝
   ⍝ The group character values will just be the names of 
   ⍝ the groups.
     res[ngi;3]←getname¨gi 4⌷xml
   ⍝
   ⍝ We want to create some kind of message indicating the 
   ⍝ pass or fail of the result.
     pass←('...failed!' '...passed.')[1+getpass¨ri 4⌷xml]
   ⍝
   ⍝ The pass results will be appended to the test name in 
   ⍝ the output.
     res[nri;3]←(getname¨ri 4⌷xml),¨pass
   ⍝
   ⍝ Each group introduces another level of nesting in the form 
   ⍝ of a ul node right below it.
     res[1,1+ngi;2]←⊂'ul'
   ⍝
   ⍝ Finally, we need to adjust the depths of the tree to turn 
   ⍝ it from a flat set of nodes into a tree with the right 
   ⍝ dependencies. We can do all of this using the shift 
   ⍝ values and the original depth vector as appropriate.
     res[(1+ngi),ngi,nri;1]←xml[gi,gi,ri;1]+(1+sgi),sgi,sri
   ⍝
   ⍝ Finally this is all boxed up into a content div.
     'div id="content"'Enclose ⎕XML res
 }
 
⍝This is a simple functin to read in a UTF-8 file.
 
 ReadFile←{
     0::⎕SIGNAL ⎕EN
     tie←⍵ ⎕NTIE 0
     ints←⎕NREAD tie 83,⎕NSIZE tie
     'UTF-8' ⎕UCS ints
 }
 

:EndClass
