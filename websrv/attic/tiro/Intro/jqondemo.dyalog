:Class jqondemo : MiPage

    :Include #.HTMLInput    ⍝ useful HTML tools

    :field public event     ⍝ the triggered event - JQ.On supplies this
    :field public what      ⍝ the id, if any, of the element that triggered the event - JQ.On supplies this


    ∇ Render req;html;data;tableopts
      :Access Public
     
      html←'h2'Enclose'JQ.On Demonstration'
      html,←'h3'Enclose'Click any table cell...'
      data←'h2'∘Enclose¨2 2⍴'Replace Me' 'Append To Me' 'Prepend To Me' 'Execute Some Javascript'
      tableopts←'border="1"'
      html,←'div align="center"'Enclose'mytable'Table data tableopts'' ''⍬ 1
      html,←#.JQ.On('#mytable' 'td')'dblclick mouseleave'
     
      req.Return html
    ∇

    ∇ APLJax req;cellid;resp
      :Access public
     
      cellid←'#',what   ⍝ format the id of the cell
      :Select what      ⍝ do different things based on the cell that was clicked
      :Case 'r1c1'
          resp←('replace'cellid)('data'('This is my new content - ',⍕⎕TS))
      :Case 'r1c2'
          resp←('append'cellid)('data' 'This is my new content')
      :Case 'r2c1'
          resp←('prepend'cellid)('data' 'This is my new content')
      :Case 'r2c2'
          resp←('execute'('$("',cellid,'").css("background-color","yellow")'))
      :EndSelect
     
      req.Return #.JSON.fromNVP resp
    ∇
:EndClass