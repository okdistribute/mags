:Namespace JQ
    ⎕IO ⎕ML ⎕WX←1 0 3
⍝ == JQ - JQuery Utilities
⍝ For more information:
⍝ * JQuery - http://jquery.com

    CRLF←⎕UCS 13 10

    eis←{2>|≡⍵:,⊂⍵ ⋄ ⍵} ⍝ Enclose if simple
    enlist←{⎕ML←2 ⋄ ∊⍵} ⍝ APL2 style enlist
    quote←{'"'∊⍵:⍵ ⋄ '"',⍵,'"'}
    ine←{0∊⍴⍺:'' ⋄ ⍵} ⍝ if not empty

    ∇ r←JQueryfn pars;jqfn;sel;jqpars;chain;script
    ⍝ pars - [1] jquery function name, [2] selectors, [3] jquery function parameters, [4] jquery function chain
    ⍝ for usage examples, see other functions in this namespace
      pars←eis pars
      jqfn sel jqpars chain←pars,(⍴pars)↓'' '' '' ''
      :If 0∊⍴chain ⋄ chain←';' ⋄ :EndIf
      sel←quote ¯2↓enlist{'".#'∊⍨1↑⍵:⍵,', ' ⋄ '#',⍵,', '}¨eis sel
      r←#.HTMLInput.JS'$(function(){$(',sel,').',jqfn,'({',jqpars,'})',chain,'});'
    ∇

    ∇ r←{page}On pars;ajax;sel;evt;attr;resp;data;what;at;id;name;type;dtype;delegate;success
    ⍝ pars - [1] selector(s) (delegates), [2] events to bind to,  [3] data to send to server [4] id if the object whose HTML is to be updated
    ⍝ [1] - a simple character vector of selector(s) or a two element vector of (selectors delegates)
    ⍝ [2] - a character vector of events to bind
    ⍝ [3] - data to be sent to the server in the form: (name {id} type what)...
    ⍝       name - the name for the piece of data
    ⍝       id - selector for where to get the data
    ⍝       type - type of data to retrieve.  one of:
    ⍝              attr - data is an attribute of the selected element
    ⍝              css - data is a css setting of the selected element
    ⍝              html - data is the html content of the selected element
    ⍝              is - see jQuery.is()
    ⍝              eval - data will be the evaluation of the what parameter
    ⍝       what - type and what are related
    ⍝              type   what                               example of what JQ.On generates
    ⍝              attr   attribute name to return           attr("id")
    ⍝              css    css setting to return              css("background-color")
    ⍝              html   what is not used and should be ''  html()
    ⍝              is     jQuery.on selector                 is(":checked")
    ⍝              eval   javascript expression              eval("confirm('Are you sure?')")
    ⍝ [4] - response handling
    ⍝       if empty, the response is assumed to be a json array of either:
    ⍝       {(replace|append|prepend: selector),(data: "data to replace with, append, or prepend)}
    ⍝       {execute: "javascript expression"}
    ⍝       if non-empty, this parameter is the selector for the element whose content will be replaced be the server response
    ⍝
     
      :Select ⊃⎕NC'page'
      :Case 9 ⋄ page.Use'JQuery' ⋄ page←page.Page ⍝ page is the request object
      :Case 0 ⋄ page←'#' ⍝ page not defined (NB - this will fail for IE!)
      :EndSelect
      page←quote page
     
      pars←eis pars
      delegate←''
      sel evt attr resp←4↑pars,(⍴pars)↓'' '' '' ''
      :If 1<|≡sel ⋄ sel delegate←sel ⋄ delegate←', ',quote delegate :EndIf
      data←'event: evt.type, what: $(evt.currentTarget).attr("id")'
      :If 2=|≡attr ⋄ attr←,⊂attr ⋄ :EndIf
      :For at :In attr
          name id type what←4↑at,(⍴at)↓4⍴⊂''
          :Select id
          :CaseList 'attr' 'css' 'html' 'is' 'serialize' ⍝ no selector specified, use evt.target
              type what←id type
              id←'evt.target'
          :Case 'eval'
              type what←id type
              id←''
          :Else
              id←(type≢'eval')/quote id
          :EndSelect
          type←type,'(',(what ine quote what),')'
          data,←',',name,': ',(id ine'$(',id,').'),type
      :EndFor
     
      :If 0∊⍴resp ⍝ if no response element specified
          dtype←'"json"'
          success←'success: function(d){if(typeof(d.replace)!="undefined"){$(d.replace).html(d.data);}else if(typeof(d.append)!="undefined"){$(d.append).append(d.data);}else if(typeof(d.prepend)!="undefined"){$(d.prepend).prepend(d.data);}else if(typeof(d.execute)!="undefined"){eval(d.execute);}}'
      :Else
          dtype←'"html"'
          success←'success: function(d){$(',(quote resp),').empty().html(d);}'
      :EndIf
     
      ajax←'$.ajax({url: ',page,', type: "POST", dataType: ',dtype,', data: {',data,'}, ',success,'});'
      r←#.HTMLInput.JS'$(function(){$(',(quote sel),').on(',(quote evt),delegate,', function(evt){',ajax,'});});'
    ∇


⍝    ∇ r←{page}On pars;ajax;sel;evt;attr;resp;data;a;at;id;name;type;dtype;delegate
⍝    ⍝ pars - [1] selector(s) (delegates), [2] events to bind to,  [3] id.attribute(s) to send, [4] id if the object whose HTML is to be updated
⍝      :Select ⊃⎕NC'page'
⍝      :Case 9 ⍝ page is the request object
⍝          page.Use'JQuery' ⋄ page←page.Page
⍝      :Case 0 ⍝ page not defined
⍝          page←'#'
⍝      :EndSelect
⍝      pars←eis pars
⍝      delegate←''
⍝      sel evt attr resp←4↑pars,(⍴pars)↓'' '' '' ''
⍝      :If 1<|≡sel ⋄ sel delegate←sel ⋄ delegate←', ',quote delegate :EndIf
⍝      data←'event: evt.type, what: $(evt.target).attr("id")'
⍝      :If 2=|≡attr ⋄ attr←,⊂attr ⋄ :EndIf
⍝      :For at :In attr
⍝          name id type a←4↑at,(⍴at)↓4⍴⊂''
⍝          :Select id
⍝          :CaseList 'attr' 'css' 'html' 'is' 'serialize' ⍝ no selector specified, use evt.target
⍝              type a←id type
⍝              id←'evt.target'
⍝          :Else
⍝              id←quote id
⍝          :EndSelect
⍝          type←'.',type,'(',(a ine quote a),')'
⍝          data,←',',name,': $(',id,')',type
⍝      :EndFor
⍝      dtype←quote(1+0∊⍴resp)⊃'html' 'script'
⍝      ajax←'$.ajax({url: ',(quote page),', type: "POST", dataType: ',dtype,', data: {',data,'}',(resp ine', success: function(data){$(',(quote resp),').empty().html(data);}'),'});'
⍝      r←#.HTMLInput.JS'$(function(){$(',(quote sel),').on(',(quote evt),delegate,', function(evt){',ajax,'});});'
⍝    ∇

:EndNamespace