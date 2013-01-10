:Namespace JQO
    (⎕IO ⎕ML ⎕WX)←1 0 3
⍝ == JQO - JQuery Other Utilities

    CRLF←⎕UCS 13 10
    ine←{0∊⍴⍺:'' ⋄ ⍵}  ⍝ if not empty
    eis←{2>|≡⍵:,⊂⍵ ⋄ ⍵} ⍝ Enclose if simple
    enlist←{⎕ML←2 ⋄ ∊⍵} ⍝ APL2 style enlist
    firstAfter←{pos str←⍵ ⋄ pos+1⍳⍨⍺⍷pos↓str} ⍝ return position of first occurrence after a position
    empty←0∘∊∘⍴

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

    ∇ r←{req}TableSorter pars;id;tablepars;jqpars;pager;html;sizes;rows;class;stub
    ⍝ req - HTTPRequest object
    ⍝ pars - id tablepars jqpars pager
    ⍝ id - the id for the table to be sorted
    ⍝ jqpars - TableSorter parameters
    ⍝ tablepars - parameters for the table (see HTMLInput.Table)
    ⍝ pager - use the tablesorterPager plug-in?
    ⍝ updates req.Response.head and returns html
     
    ⍝ Usage Notes:
    ⍝ the table is assigned a class of "tablesorter" by this function
    ⍝ the first row is considered a header row
      pars←eis pars
      id tablepars jqpars pager←4↑pars,(⍴pars)↓'' '' '' 0
      :If 0∊⍴id ⋄ id←'myTableSorter' ⋄ :EndIf
      :If 9=⎕NC'req'
          req.Use'jquery.tablesorter',pager/'.pager'
      :EndIf
      class←'class="tablesorter"'
      :If 2=⍴⍴tablepars ⋄ tablepars←,⊂tablepars ⋄ :EndIf
      tablepars←tablepars,(⍴,tablepars)↓(1 1⍴⊂'$nbsp;')'' '' '' 1 ⍝ see HTMLInput.Table for
      :If 1∨.≠5⊃tablepars ⋄ 'TableSorter header row must be 1'⎕SIGNAL 11 ⋄ :EndIf
      (2⊃tablepars)←'tablesorter'insertClass 2⊃tablepars
      r←id #.HTMLInput.Table tablepars
      rows←¯1+⍬⍴⍴1⊃tablepars ⍝ rows of table data
      pager∧←10<rows
      :If pager
          sizes←rows{(⍺+.≥⍵)↑⍵}10 25 50
          sizes←sizes,(rows≠¯1↑sizes)/rows
          sizes←sizes,[1.1](¯1↓sizes),⊂'All'
          :With #.HTMLInput
              stub←'img src="/JQuery/PlugIns/TableSorter/css/pager/'
              html←Tag stub,'first.png" class="first"'
              html,←Tag stub,'prev.png" class="prev"'
              html,←Tag'input type="text" readonly="readonly" class="pagedisplay"'
              html,←Tag stub,'next.png" class="next"'
              html,←Tag stub,'last.png" class="last"'
              html,←DropDown sizes(⍬⍴sizes)'class="pagesize"'
              r,←'div id="pager" class="pager"'Enclose'form'Enclose html
              jqpars,←(0∊⍴jqpars)↓',widthFixed:true'
          :EndWith
      :EndIf
      r,←#.JQ.JQueryfn'tablesorter'id jqpars(pager/'.tablesorterPager({container: $("#pager")})')
    ∇

⍝ treeview

    ∇ html←{req}Treeview pars;id;levels;items;jqpars;diff;isparent;end;repeat;li
      pars←{2>|≡⍵:,⊂⍵ ⋄ ⍵}pars
      id levels items jqpars←4↑pars,(⍴pars)↓''⍬'' ''
      :If 0∊⍴id ⋄ id←'tree' ⋄ :EndIf
      :If 9=⎕NC'req'
          req.Use'jquery.treeview'
      :EndIf
      diff←2-/levels,1↑,levels
      'A child item cannot be more than one level below its parent.'⎕SIGNAL(¯1∨.>diff)/600
      isparent←0>diff
      end←0⌈diff
      repeat←{(⍵×⍴⍺)⍴⍺}
      li←(('<li id="'∘,¨((id,'_')∘,¨⍕¨⍳⍴levels)),¨⊂'">'),¨'<span>'∘repeat¨isparent
      html←li,¨items,¨('</li>' '</span><ul>')[1+isparent]
      html←{⎕ML←1 ⋄ ∊⍵}html,¨('</ul></li>')∘repeat¨end
      html←('ul id="',id,'"')#.HTMLInput.Enclose html
      html,←#.JQ.JQueryfn'treeview'id jqpars
    ∇

⍝ jsTree

    ∇ html←{req}jsTree pars;id;levels;items;jqpars;diff;isparent;end;repeat;li
      pars←{2>|≡⍵:,⊂⍵ ⋄ ⍵}pars
      id levels items jqpars←4↑pars,(⍴pars)↓''⍬'' ''
      :If 0∊⍴id ⋄ id←'tree' ⋄ :EndIf
      :If 9=⎕NC'req'
          req.Use'jquery.jstree'
      :EndIf
      diff←2-/levels,1↑,levels
      'A child item cannot be more than one level below its parent.'⎕SIGNAL(¯1∨.>diff)/600
      isparent←0>diff
      end←0⌈diff
      repeat←{(⍵×⍴⍺)⍴⍺}
      li←('<li id="'∘,¨((id,'_')∘,¨⍕¨⍳⍴levels)),¨⊂'"><a href="#">'
      html←li,¨items,¨('</a></li>' '</a><ul>')[1+isparent]
      html←{⎕ML←1 ⋄ ∊⍵}html,¨('</ul></li>')∘repeat¨end
      html←CRLF,('div id="',id,'"')#.HTMLInput.Enclose'ul'#.HTMLInput.Enclose html
      html,←#.JQ.JQueryfn'jstree'id jqpars
    ∇

:EndNamespace