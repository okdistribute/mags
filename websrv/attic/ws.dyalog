:Namespace WS

    ⎕IO←0

    ⍝ Services List:
    ⍝
    ⍝ GetInstructors: Provides a list of the instructors
    ⍝   Pattern: 2
    ⍝   Input:
    ⍝     networkid    boolean (default: 1)
    ⍝     firstname    boolean (default: 1)
    ⍝     lastname     boolean (default: 1)
    ⍝   Output: TOR
    ⍝ ListComments: Lists all the comments
    ⍝   Pattern: 4
    ⍝   Input: N/A
    ⍝   Output: TOR
    ⍝ AddComments: Add comments to the set of comments
    ⍝   Pattern: 1
    ⍝   Input: text+
    ⍝   Output: N/A

    ⍝ BuildAPI
    ∇ R←BuildAPI;pvm;mthd;in
      R←⍬
      pvm←1 2⍴'pattern' 2
      pvm⍪←'documentation' 'Lists all instructors'
      mthd←1 4⍴1 'GetInstructors' ''pvm
      in←0 4⍴''
      pvm←1 2⍴'datatype' 'boolean'
      pvm⍪2 2⍴'minimum' 1 'maximum' 1
      pvm⍪←'documentation' 'Return networkid field'
      in⍪←1 4⍴1 'networkid' ''pvm
      pvm[1;1]←⊂'Return firstname field'
      in⍪←1 4⍴1 'firstname' ''pvm
      pvm[1;1]←⊂'Return lastname field'
      in⍪←1 4⍴1 'lastname' ''pvm
      R,←⊂mthd in BuildTorMLS
      pvm←1 2⍴'pattern' 4
      pvm⍪←'documentation' 'Lists all the comments'
      mthd←1 4⍴1 'ListComments' ''pvm
      in←0 4⍴''
      R,←⊂mthd in BuildTorMLS
      pvm←1 2⍴'pattern' 1
      pvm⍪←'documentation' 'Adds comments to the server'
      mthd←1 4⍴1 'AddComments' ''pvm
      in←0 4⍴''
      pvm←1 2⍴'datatype' 'string'
      pvm⍪←'documentation' 'Value of a comment'
      pvm⍪←'minimum' 1
      in⍪←1 4⍴1 'text' ''pvm
      R,←⊂mthd in(0 4⍴'')
    ∇

    ⍝ BuildTorMLS
    ⍝   R   TOR MLS descriptor
    ⍝ Many results come in as TOR results, which is a simple
    ⍝ way of describing tabular results. This variable stores
    ⍝ the MLS descriptor of TOR results.
    ∇ R←BuildTorMLS;pvm
      R←0 4⍴''
      pvm←1 2⍴'minimum' 1
      pvm⍪←'documentation' 'Root TOR node'
      R⍪←1 'RecordSet' ''pvm
      pvm←1 2⍴'documentation' 'Record or Row node'
      R⍪←2 'Record' ''pvm
      pvm[0;1]←⊂'Field node'
      R⍪←3 'Field' ''pvm
    ∇

    ⍝ GetElem <name>
      GetElem←{
          (⍺[;2]⍳⊂⍵)⊃a[;3],⊂''
      }

    ⍝ <field names> Mat2Tor <Record Matrix>
      Mat2Tor←{
          vals←⍪,(⊂''),⍵
          nams←(⍴vals)⍴(⊂'Record'),(⍴⍺)⍴⊂'Field'
          dpth←(⍴vals)⍴2,(⍴⍺)⍴3
          pvms←(⍴vals)⍴(⊂''),{1 2⍴'name'⍵}¨⍺
          (1 4⍴1 'RecordSet' '' '')⍪dpth,nams,vals,pvms
      }

    ⍝ GetInstructors
      GetInstructors←{
          flds←#.DB.Instructor.names
          bv←0≠(,'0')(,'1')⍳⍵[;2]
          rfl←bv/flds
          res←rfl Mat2Tor #.Main.GetInstructors rfl
          1 res
      }

    ⍝ ListComments
      ListComments←{
          res←(⊂'text')Mat2Tor #.Main.ListComments
          1 res
      }
      
    ⍝ AddComments
      AddComments←{
          vals←(0≠⊃∘⍴¨vals)/vals←⍵[;2]
          0<⍴vals:0 'Success!'⊣#.Main.AddComments vals
          0 'No values provided.'
      }
       
:EndNamespace
