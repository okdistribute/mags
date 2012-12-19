:Namespace JQUI
    ⎕IO ⎕ML ⎕WX←1 0 3
⍝ == JQUI - JQueryUI
⍝ For more information:
⍝ * JQuery - http://jquery.com
⍝ * JQUery UI - http://jqueryui.com

    CRLF←⎕UCS 13 10

⍝ --- Utility functions ---

    ine←{0∊⍴⍺:'' ⋄ ⍵}  ⍝ if not empty
    eis←{2>|≡⍵:,⊂⍵ ⋄ ⍵} ⍝ Enclose if simple
    enlist←{⎕ML←2 ⋄ ∊⍵} ⍝ APL2 style enlist
    firstAfter←{pos str←⍵ ⋄ pos+1⍳⍨⍺⍷pos↓str} ⍝ return position of first occurrence after a position
    empty←{0∊⍴⍵}

    ∇ r←class insertClass attrs;m;beg;end;q;f
     ⍝ insert class into a list of attributes, if there's already a class= attribute append class to it
      :If ~∨/m←'class='⍷attrs ⋄ r←'class="',class,'"',(0∊⍴attrs)↓' ',attrs ⋄ :Return ⋄ :EndIf
      q←(6+beg←m⍳1)⊃attrs,' '
      :If q∊'''"' ⋄ end←¯1+q firstAfter(6+beg)attrs ⋄ r←(end↑attrs),' ',class,end↓attrs
      :Else
          f←~(⍴attrs)≥end←¯1+' 'firstAfter(5+beg)attrs
          r←attrs
          r[beg+5]←⊂'="'
          r←enlist((end-f)↑r),(f↓' ',class,'"'),end↓r
      :EndIf
    ∇

⍝ --- Widget functions ---

    ∇ r←{req}Accordion pars;id;hdrs;content;jqpars
    ⍝ req - HTTPRequest object
    ⍝ id - the id for the accordion
    ⍝ jqpars - Accordion parameters
    ⍝ hdrs - n-element array of header names for each accordion folder
    ⍝ content - n-element array of content for each accordion folder
    ⍝ updates req.Response.head and returns html
      pars←eis pars
      id hdrs content jqpars←4↑pars,(⍴pars)↓'' '' '' ''
      :If 0∊⍴id ⋄ id←'myAccordian' ⋄ :EndIf
      :If 9=⎕NC'req' ⋄ req.Use'JQueryUI' ⋄ :EndIf
      hdrs←#.HTML.h3¨('href' '#')∘#.HTML.a¨hdrs
      content←#.HTML.div¨content
      r←'id'id #.HTML.div,hdrs,[1.1]content
      r,←#.JQ.JQueryfn('accordion'id jqpars)
    ∇

    ∇ r←{req}DatePicker pars;id;editpars;jqpars
    ⍝ req - HTTPRequest object
    ⍝ pars - id editpars jqpars
    ⍝ id - the id for the datepicker
    ⍝ editpars - parameters for the edit field (see HTMLInput.Edit)
    ⍝ jqpars - datepicker parameters
    ⍝ updates req.Response.head and returns html
      :If 9=⎕NC'req' ⋄ req.Use'JQueryUI' ⋄ :EndIf
      pars←eis pars
      id editpars jqpars←pars,(⍴pars)↓''⍬''
      :If 0∊⍴id ⋄ id←'myDatePicker' ⋄ :EndIf
      r←id #.HTMLInput.Edit editpars
      r,←#.JQ.JQueryfn'datepicker'id jqpars
    ∇

    ∇ r←{req}Dialog pars;id;title;innerhtml;jqpars
    ⍝ req - HTTPRequest object
    ⍝ id - the id for the dialog
    ⍝ jqpars - Dialog parameters
    ⍝ title - title for the dialog
    ⍝ innerhtml - body for the dialog
    ⍝ updates req.Response.head and returns html
      pars←eis pars
      id title innerhtml jqpars←4↑pars,(⍴pars)↓'' '' '' ''
      :If 9=⎕NC'req' ⋄ req.Use'JQueryUI' ⋄ :EndIf
      r←('title'title'id'id)#.HTML.div innerhtml
      r,←#.JQ.JQueryfn'dialog'id jqpars
    ∇

    ∇ r←{req}Draggable pars;id;jqpars
    ⍝ req - HTTPRequest object
    ⍝ id - the selector(s) (generally ids) for items to be dragged
    ⍝ jqpars - Draggable parameters (if supplied, will override the default)
    ⍝ updates req.Response.head and returns html
      pars←eis pars
      id jqpars←2↑pars,(⍴pars)↓'' ''
      :If empty id ⋄... ⋄ :EndIf ⍝ id is required
      :If 9=⎕NC'req' ⋄ req.Use'JQueryUI' ⋄ :EndIf
      :If 0∊⍴jqpars ⋄ jqpars←'appendTo: "body", helper: "clone"' ⋄ :EndIf
      r←#.JQ.JQueryfn('draggable'id jqpars)
    ∇

    ∇ r←{req}Droppable pars;jqpars;accept;id;update;page
    ⍝ req - HTTPRequest object
    ⍝ id - the selector(s) for the droppable elements
    ⍝ accept - the selectors(s) for what can be dropped on them
    ⍝ update - the selector(s) for the element whose html to update if the server returns data (empty if no data expected)
    ⍝ jqpars - Droppable parameters (if supplied, will override the default)
    ⍝ updates req.Response.head and returns html
    ⍝
    ⍝ NB: the default behavior expects id attributes on both the dragger and droppee
      pars←eis pars
      id accept update jqpars←4↑pars,(⍴pars)↓'' '' '' ''
      :If ∨/empty¨id accept ⋄... ⋄ :EndIf ⍝ id and accept are required
      :If 9=⎕NC'req' ⋄ req.Use'JQueryUI' ⋄ page←req.Page
      :Else ⋄ page←'#'
      :EndIf
      :If empty jqpars
          jqpars←'accept: "',accept,'", activeClass: "ui-state-default", hoverClass: "ui-state-hover", '
          jqpars,←'drop: function(evt, ui){$.post("',page,'", { event: "drop", drag: ui.draggable.attr("id"), receiver:$(this).attr("id") }'
          :If ~empty update
              jqpars,←', function(data){$("',update,'").html(data)}, "html"'
          :EndIf
          jqpars,←');}'
      :EndIf
      r←#.JQ.JQueryfn('droppable'id jqpars)
    ∇

    ∇ r←{req}Sortable pars;ids;lists;styles;usehd;jqpars;chain;liststyle;itemstyle;style;js;callback;lids;cbcode;cbids;i
      pars←eis pars
      usehd ids lists styles jqpars chain callback←7↑pars,(⍴pars)↓0 '' '' '' '' '' 0
      :If 9=⎕NC'req'
          req.Use'JQueryUI'
          :If 0∊⍴styles ⋄ liststyle←itemstyle←''
          :Else ⋄ liststyle itemstyle←styles
          :EndIf
          liststyle←liststyle,⍨'list-style-type' 'none' 'margin' 0 'padding' 0 'float' 'left' 'margin-right' '10px' 'background' '#eee' 'padding' '5px' 'width' '143px'
          itemstyle←itemstyle,⍨'margin' '5px' 'padding' '5px' 'font-size' '1.2em' 'width' '120px'
          ids←eis ids
          style←⊂('#'∘,¨ids)#.HTMLInput.MakeStyle liststyle
          style,←⊂('#'∘,¨ids,¨⊂' li')#.HTMLInput.MakeStyle itemstyle
          style req.Style''
      :EndIf
     
      lists←eis¨lists
      :If callback
          lids←(⊂¨ids),¨¨'_'∘,∘⍕¨¨⍳∘⍴¨lists ⍝ list IDs
          lids←'li class="ui-state-default" id="'∘,∘(,∘'"')¨¨lids
          lists←lids #.HTMLInput.Enclose¨¨lists
      :Else
          lists←'li class="ui-state-default"'∘#.HTMLInput.Enclose¨¨lists
      :EndIf
      :If usehd
          lists←{w←⍵ ⋄ f←'ui-state-disabled'insertClass 1⊃w ⋄ w[1]←⊂f ⋄ w}¨lists
      :EndIf
      lists←(1∘⌽¨'"ul id="'∘,¨ids)#.HTMLInput.Enclose¨lists
      jqpars←2↓enlist', '∘,¨(⊂'')~⍨((1<⍴lists)/'connectWith: "ul"')(usehd/'items: "li:not(.ui-state-disabled)"')jqpars
      :If callback
          js←{'{',2↓(enlist ⍵),'}'}{', ',⍵,': $("#',⍵,'").sortable("serialize")'}¨ids
          cbcode←', update: function(){$.post("',req.Page,'", ',js,')}'
          jqpars,←(2×empty jqpars)↓cbcode
      :EndIf
      chain←'.disableSelection()',chain
      js←#.JQ.JQueryfn'sortable'ids jqpars chain
      r←(enlist CRLF∘,¨lists),CRLF,js,'div style="clear: both;"'#.HTMLInput.Enclose''
    ∇

    ∇ r←{req}Tabs pars;id;tabnames;content;jqpars;uris;tabids;hrefs
    ⍝ req - HTTPRequest object
    ⍝ id - the id for the tabs
    ⍝ jqpars - Tabs parameters
    ⍝ tabnames - n-element vector of charvec of names to appear on the tabs
    ⍝ content - n-element vector of charvecs with the HTML content for each tab
    ⍝ updates req.Response.head and returns html
      :If 9=⎕NC'req' ⋄ req.Use'JQueryUI' ⋄ :EndIf
      pars←eis pars
      id tabnames content jqpars←4↑pars,(⍴pars)↓'' '' '' ''
      :If 0∊⍴id ⋄ id←'myTabs' ⋄ :EndIf
      tabnames←eis tabnames
      content←eis content
      uris←(empty¨content)<{∧/⍵∊'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%-._~:/?#[]@!$&''()*+,;='}¨content ⍝ identify likely URIs
      tabids←id∘,¨'-'∘,¨⍕¨⍳⍴tabnames
      hrefs←'#',¨tabids
      (uris/hrefs)←uris/content
      hrefs←'a href='∘,¨#.HTMLInput.quote¨hrefs
      r←'ul'#.HTMLInput.Enclose enlist'li'∘#.HTMLInput.Enclose¨hrefs #.HTMLInput.Enclose¨tabnames
      :If ~∧/uris
          r,←enlist('div id="'∘,¨(,∘'"')¨(~uris)/tabids)#.HTMLInput.Enclose¨(~uris)/content
      :EndIf
      r←'id'id #.HTML.div r
      r,←#.JQ.JQueryfn'tabs'id jqpars
    ∇

:EndNamespace