:Namespace JQM

⍝ JQuery Mobile namespace. V1.04 Dyalog 2012

⍝ This namespace contains classes to deal with JQuery Mobile.

    ⎕IO ⎕ML←1

    Create←{⎕NEW JQM ⍵}
    Add←{⎕NEW ⍵}

    :class JQM ⍝ jQuery Mobile WebPage class

        :field public Request
        :field public Title←''  ⍝ application Title
        :field public Body

        ∇ Make req
          :Implements constructor
          :Access public
          Request←req
          Request.Use'JQueryMobile'
          Request.Meta'name="viewport" content="width=device-width, initial-scale=1"'
          Body←⎕NEW HtmlElement
          :Trap 6 ⋄ ⎕DF Title←req.Server.Config.Name ⋄ :EndTrap
        ∇

        ∇ r←Render
          :Access public
          :If 0<⍴Title ⋄ Request.Response.HTMLHead,←'title'#.HTMLInput.Enclose Title ⋄ :EndIf
          r←Body.Render
        ∇

        ∇ {r}←AddPage t;title;p;name ⍝ individual page Title
          :Access public
          t←⊂⍣(2>|≡t)+t
          (title name)←t,(⍴,t)↓'' ''
          p←⎕NEW Page(''('data-title'title))
          p.Name←name
          r←(Body.Add p).Last
        ∇
    :EndClass  ⍝ JQM

⍝ Pages are made of a series of HTML elements

    :class HtmlElement
        :field public TAG←''
        :field public InnerHTML←'' ⍝ this is a series of strings/instances/class+parms
        :field public ATTR

        ∇ Make0
          :Implements constructor
          :Access public
          ATTR←⎕NS''
        ∇
        ∇ Make1 t    ⍝ this can be any length
          :Implements constructor
          :Access public
          TAG←t ⋄ ATTR←⎕NS''
        ∇
        ∇ Make2(t i)
          :Implements constructor
          :Access public
          TAG←t ⋄ ATTR←⎕NS''
          Add i
        ∇
        ∇ Make3(t i a)
          :Implements constructor
          :Access public
          TAG←t ⋄ ATTR←⎕NS''
          Add i
          Attr a
        ∇

        ∇ r←a Enclose w
          :Access public
          r←a #.HTMLInput.Enclose w
        ∇

        ∇ r←RenderElements InnerHTML
          :Access public
        ⍝ This fn is used to avoid replacing the Field InnerHTML
          r←Render ⍝ Render uses global 'InnerHTML'
        ∇

        ∇ r←Render;av;t;vs
          :Access public
          av←''
          :If 0<⍴vs←ATTR.⎕NL ¯2
              av←∊{' ',(HtmlAttrFmt ⍵),'=',Quote,⍕ATTR⍎⍵}¨vs
          :EndIf
          t←TAG,(0<⍴,TAG)/av
          r←t Enclose Compose InnerHTML
        ∇

        ∇ r←eis w
          :Access public
          r←⊂⍣((326∊⎕DR w)<2>|≡w),w ⍝ enclose if simple and not mixed
        ∇
        ∇ r←a ine w
          :Access public
          r←''
          →0⍴⍨0⍴∊w
          r←a,'=',Quote w
        ∇

        ∇ r←Quote a;b
          :Access public
          b←1↓<⌿¯1 0⌽'\"'∘.=';',a ⍝ keep \" as is
          (b/a)←⊂'&quot;'
          r←1⌽'""',∊a
        ∇

        ∇ {r}←Add args;t;i
        ⍝ add "something" to the InnerHTML
        ⍝ args can be an instance, a class, or just html/text
          :Access public
          :If ~0∊⍴args
              InnerHTML,←⎕NEW∘{2<⍴,⍵:(⊃⍵)(1↓⍵) ⋄ ⍵}⍣(isClass⊃args)eis args
          :EndIf
          r←⎕THIS
        ∇

        ∇ {r}←Last
          :Access public
          r←⊃⌽InnerHTML
        ∇

        isClass←{9.4∊⎕nc⊂,'⍵'}

        ∇ {r}←AddBR
          :Access public
          r←Add⊂'<br/>',⎕UCS 13 10
        ∇

        ∇ r←postrender r
          :Access public overridable
        ∇

        ∇ r←Compose list;x
          :Access public
          r←''
          →0↓⍨⍴,list
          :For x :In eis list
              r,←{326=⎕DR ⍵:postrender ⍵.Render ⋄ ⍕⍵⊣÷≡⍵}x ⍝ ** TEMP: ÷≡⍵ to detect simple scalars: there should be none
          :EndFor
        ∇

⍝ Notes about attributes:
⍝ To make HTML attributes more easily accessible from APL, and to not encumber this implementation
⍝ trying to approach a complete HTML implementation we've done the following:
⍝ - we are NOT attempting to model every valid HTML attribute name, we've tried to implement a subset that addresses the vast majority of common usage patterns
⍝ - while both - and _ are valid in HTML attribute names, we translate - to ∆ in the APL attribute name
⍝ - while HTML attributes are case insensitive, APL names aren't, so attrs.(this THIS) are two separate APL variables

        ∇ {r}←{vals}Attr atts;mask
          :Access Public
          →0↓⍨⍴,atts ⍝ anything to do?
          :If 0=⎕NC'vals'
              :Select |≡atts
              :Case 2 ⍝ name/value pairs in a simple list
                  mask←(⍴atts)⍴1 0
                  ⎕SIGNAL(¯1↑mask)/5
                  vals←(~mask)/atts
                  atts←mask/atts
              :Case 3 ⍝ a list of name/value pairs
                  ⎕SIGNAL(2∨.≠∊⍴¨atts)/5
                  (atts vals)←↓⍉↑atts
              :Else ⋄ ⎕SIGNAL 36 ⍝ incompatible array
              :EndSelect
          :EndIf
          (eis atts)SetAttr¨eis vals
          r←⎕THIS
        ⍝ ATTR[eis atts]←eis vals
        ∇

    ⍝ :property Keyed ATTR          ⍝ should we take into account "MyAttrs"?
    ⍝ :access public
    ⍝ ∇ set ra;i;att;n
    ⍝  b←~n←(⍴_Attr)<i←_Attr⍳att←eis ra.Indexers
    ⍝  (_Val _Attr),⍨←b∘/¨ra.NewValue att
    ⍝   _Val[i++/n]←n/ra.NewValue
    ⍝ ∇

        ∇ att SetAttr val
        ⍝ ATTR[att]←eis val
          {}⍎'ATTR.',(AplAttrFmt att),'←val'
        ∇

        ∇ a←HtmlAttrFmt a
          ((a='∆')/a)←'-'
        ∇
        AplAttrFmt←{('∆',⍵)[('-',⍵)⍳⍵]}

    :endclass  ⍝ HtmlElement


    :Class basePage : HtmlElement  ⍝ see Page and Dialog

    ⍝ A page is made up of a Header, some Contents and a Footer
    ⍝ It may also support a submission Method
        :Field public Head
        :Field public Foot
        :Field public Contents
        :Field public FormID←''
        :Field public FormMethod←''
        :Field public FormAction←''
        :Field private useForm←0

        ∇ Make0
          :Access Public
          :Implements Constructor
        ∇

        ∇ Make1 args
          :Access Public
          :Implements Constructor :Base args
        ∇

        ∇ {r}←AddFooter ih
          :Access public
          :If {6::0 ⋄ 1⊣Foot}0
              Foot.InnerHTML,←ih
          :Else
              Foot←⎕NEW Footer ih
          :EndIf
          r←Foot
        ∇

        ∇ {r}←AddHeader ih
          :Access public
          :If {6::0 ⋄ 1⊣Head}0
              Head.InnerHTML,←ih
          :Else
              Head←⎕NEW Header ih
          :EndIf
          r←Head
        ∇

        ∇ {r}←AddContent ih
          :Access public
          :If {6::0 ⋄ 1⊣Contents}0
              Contents.InnerHTML,←ih
          :Else
              Contents←⎕NEW Content ih
          :EndIf
          r←Contents
        ∇

        ∇ {r}←UseForm arg;a;i
          :Access public
          useForm←1
          arg←eis arg
          :For a :In arg
              :If 3≠i←⌈0.5×'GET' 'get' 'POST' 'post'⍳⊂a ⋄ FormMethod←i⊃'get' 'post'
              :ElseIf 9.1=⎕NC'a' ⋄ FormAction←a.Page
              :ElseIf ∨/'/\.#'∊a ⋄ FormAction←a
              :Else ⋄ FormID←'id'a
              :EndIf
          :EndFor
        ∇

        ∇ r←Render
          :Access public
        ⍝ This is a basePage rendering fn.
          r←'' ⍝ InnerHTML is always there but may be empty
          r,←{6::'' ⋄ Head.Render}⍬
          r,←{6::'' ⋄ Contents.Render}⍬
          r,←{6::'' ⋄ Foot.Render}⍬
        ⍝ The page contents goes first
          r←RenderElements(⊂r),InnerHTML ⍝ add any remaining tag
          :If useForm
              r←('form',∊' action' ' method' ' id'ine¨FormAction FormMethod FormID)Enclose r
          :EndIf
        ∇

    :EndClass ⍝ basePage

    :class Form : HtmlElement
        ∇ Make0
          :Implements constructor :base 'form'
          :Access public
        ∇

    :EndClass

    :Class CheckboxGroup: HtmlElement
        :Field public readonly MyAttrs←,⊂'data-mini'
        :Field public ID
        :Field public Label
        :Field public Choices
        :Field public Container
        :Field public Group
        _horizontal←0
        :Field public ButtonType←'checkbox'

        ∇ Make(i c l)
          :Access public
          :Implements constructor
          (ID Choices Label)←i c l
          Container←⎕NEW FieldContain
          Group←⎕NEW FieldSet
          ⎕DF'RC ',i
        ∇

        ∇ {r}←Horizontal onoff
          :Access Public
          _horizontal←onoff
          r←⎕THIS
        ∇

        ∇ r←Render;c;cnt;n;v;nv
          :Access public
          Container.InnerHTML←''
          Group.Legend←Label
          :If _horizontal ⋄ 'horizontal'Group.Attr'data-type' ⋄ :EndIf
          :If 2=⍴⍴c←Choices ⋄ nv←⊂[1]c
          :ElseIf 2=≡c ⋄ nv←c c ⍝ name=value
          :Else ⋄ nv←↓⍉↑c
          :EndIf
          Group.InnerHTML←''
          cnt←1
          :For (n v) :InEach nv
              :If 326∊⎕DR n ⋄ n←n.Render ⋄ :EndIf
              Group.Add Input((ID,'-',⍕cnt)ButtonType n('name'ID'value'v))
              cnt+←1
          :EndFor
          Container.Add Group
          InnerHTML←Container
          r←⎕BASE.Render
        ∇
    :endclass

    :class RadioGroup: CheckboxGroup

        ∇ Make(i c l)
          :Access public
          :Implements constructor  :base  i c l
          ButtonType←'radio'
          ⎕DF'RG ',i
        ∇

    :endclass  ⍝ RadioGroup

    :class ControlGroup: CheckboxGroup

        ∇ Make(i c l)
          :Access public
          :Implements constructor  :base  i c l
          ButtonType←'button'
         ⍝ TAG←'div data-role="controlgroup"'
          ⎕DF'CG ',i
        ∇

    :endclass  ⍝ ControlGroup


    :Class FieldContain : HtmlElement
        :Field public readonly MyAttrs←,⊂'data-mini'
        :field public Label
        :field public LabelPos←'before' ⍝ before or after

        ∇ Make0
          :Access public
          :Implements constructor :Base ('div' '' ('data-role' 'fieldcontain'))
        ∇

        ∇ r←Render
          :Access public
          :If {6::0 ⋄ 1⊣Label}0
              InnerHTML←(LabelPos≢'before')⌽('label'Enclose Label)InnerHTML
          :EndIf
          r←⎕BASE.Render
        ∇
    :EndClass ⍝ FieldContain


    :Class FieldSet : HtmlElement ⍝ This is a container. It may have the attribute class="ui-grid-solo/a/b/c/d".

        :field public readonly MyAttrs←'data-mini' 'data-type'
        :field public Legend

        ∇ Make0
          :Access public
          :Implements constructor :Base 'fieldset data-role="controlgroup"'
        ∇

        ∇ Make1 args
          :Access Public
          :Implements Constructor :Base (⊂'fieldset data-role="controlgroup"'),eis args
        ∇

        ∇ {r}←AddElement e;n
          :Access public
          n←5⌊⍴InnerHTML←InnerHTML,e
          TAG←1⌽'"fieldset class="ui-block-',n⊃(⊂'solo'),'abcd'
          r←⎕THIS
        ∇

        ∇ r←postrender r
          :Access public override
          r←'div class="ui-block-a"'Enclose r
        ∇

        ∇ r←Render;t
          :Access public
          t←''
          :If {6::0 ⋄ 1⊣Legend}0
              t←⊂'legend'Enclose Legend
          :EndIf
          InnerHTML←t,InnerHTML
          r←⎕BASE.Render
        ∇
    :EndClass ⍝ FieldSet


    :Class Label : HtmlElement
        ∇ Make0
          :Access public
          :Implements constructor :Base ('label')
        ∇

        ∇ Make1 ih
          :Access Public
          :Implements Constructor :Base ('label' ih)
        ∇

        ∇ Make2(for ih)
          :Access Public
          :Implements Constructor :Base ('label' ih ('for' for))
        ∇
    :EndClass  ⍝ Label



    :Class Page : basePage
        :Field public readonly MyAttrs←'data-add-back-btn' 'data-back-btn-next' 'data-back-btn-theme' 'data-dom-cache' 'data-overlay-theme' 'data-url' 'data-theme' 'data-content-theme' 'data-overlay-theme'

        ∇ Make0
          :Access public
          :Implements constructor :Base 'div'
          ATTR.data∆role←'page'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base  (⊂'div'),args
          ATTR.data∆role←'page'
        ∇
    :EndClass  ⍝ Page



    :Class Dialog : basePage
        :Field public readonly MyAttrs←'data-close-btn-text' 'data-dom-cache' 'data-overlay-theme' 'data-theme' 'data-title'

        ∇ Make0
          :Access public
          :Implements constructor :Base ('div')
          ATTR.data∆role←'dialog'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base (⊂ 'div'),eis args
          ATTR.data∆role←'dialog'
        ∇
    :EndClass  ⍝ basePage


    :Class DialogLink : HtmlElement
        :Field public readonly MyAttrs←,⊂'data-transition'

        ∇ Make2(href ih)
          :Access public
          :Implements constructor :Base ('a' ih (('href' href)('data-rel' 'dialog')))
        ∇
    :EndClass  ⍝ DialogLink


    :Class Button : HtmlElement
        :Field public readonly MyAttrs← 'data-corners' 'data-icon'  'data-iconpos'  'data-iconshadow'  'data-inline'  'data-mini'  'data-shadow' 'data-theme'

        ∇ Make1 Type ⍝ type is one of: a, button, submit, reset, image
          :Access public
          :Implements constructor
          Build Type
        ∇

        ∇ Make2(Type args)
          :Access public
          :Implements constructor :Base '' '' args
          Build Type
        ∇

        ∇ Build Type
          :Select ,Type
          :Case ,'a'
              TAG←'a data-role="button"'
          :Case 'button'
              TAG←'button'
          :Else
              TAG←'input type="',Type,'"'
          :EndSelect
        ∇
    :EndClass  ⍝ Button


    :Class BackButton : Button

        ∇ Make1 cap
          :Access public
          :Implements constructor :Base 'a'
          Attr'data-rel' 'back' 'data-icon' 'delete'
          InnerHTML←cap
        ∇

        ∇ Make2(cap attr)
          :Access public
          :Implements constructor :Base 'a'
          Attr'data-rel' 'back' 'data-icon' 'delete'
          Attr attr
          InnerHTML←cap
        ∇
    :endclass  ⍝ BackButton

    :Class SubmitButton : Button

        ∇ Make1 cap
          :Access public
          :Implements constructor :Base 'button'
          Attr'type' 'submit'
          InnerHTML←cap
        ∇

        ∇ Make2(cap attr)
          :Access public
          :Implements constructor :Base 'button'
          Attr'type' 'submit'
          Attr attr
          InnerHTML←cap
        ∇
    :endclass  ⍝ SubmitButton


    :class Input : HtmlElement  ⍝?
        :field public readonly MyAttrs←'data-mini' 'data-theme'
        :field public Type←'text' ⍝ HTML5 <input type="...">
        :field public Label←''
        :field public LabelPos←'after' ⍝ valid = 'before'|'after'

        ∇ Make arg;i;att
        ⍝ The argument may be simple, it is then an ID; otherwise it is multiple arguments
          :If 1≠≡i←,arg
              (ID Type Label att)←i,(⍴i)↓0 0 '' ''
          :EndIf
          :Implements constructor :base 'input' '' (('type' Type)('id' ID)('name' ID))
          :Access public
          Attr att
        ∇

        ∇ r←Render;l
          :Access public
          r←⎕BASE.Render
          :If ~0∊⍴Label
              r←'label'Enclose∊(LabelPos≡'after')⌽Label r
          :EndIf
        ∇
    :endclass  ⍝ Input

    :Class Checkbox : HtmlElement  ⍝?
        :field public readonly MyAttrs←'data-mini' 'data-theme'

        ∇ Make0
          :Access public
          :Implements constructor :Base
          TAG←'input type="checkbox"'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'input type="checkbox"'
        ∇

        :property checked
        :access public
            ∇ set v
              :If 0≡v.NewValue ⋄ ATTR.⎕EX'checked'
              :Else ⋄ ATTR.checked←'checked'
              :EndIf
            ∇
            ∇ r←get
              r←{6::0 ⋄ 1⊣ATTR.checked}0
            ∇
        :endproperty
    :EndClass  ⍝ Checkbox



    :Class Collapsible : HtmlElement
        :Field public readonly MyAttrs←'data-collapsed' 'data-collapsed-icon' 'data-content-theme' 'data-expanded-icon' 'data-iconpos' 'data-mini' 'data-theme'
        :Field public heading  ⍝ ??? where is this used?
        :Field public HLevel
        :Field public Contents

        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'div data-role="collapsible"'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'div data-role="collapsible"'
        ∇

        ∇ r←Render
          :Access public
          InnerHTML←Contents,⍨(¯2↑'h',⍕HLevel)#.HTMLInput.Enclose heading
          r←⎕BASE.Render
        ∇
    :EndClass  ⍝ Collapsible



    :Class CollapsibleSet : HtmlElement  ⍝?
        :Field MyAttrs←'data-collapsed-icon' 'data-content-theme' 'data-expanded-icon' 'data-iconpos' 'data-mini' 'data-theme'

        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'div data-role="collapsible-set"'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'div data-role="collapsible-set"'
        ∇
    :EndClass  ⍝ CollapsibleSet



    :Class Content : HtmlElement
        :Field public readonly MyAttrs←,⊂'data-theme'

        ∇ Make0
          :Access public
          :Implements constructor :Base 'div data-role="content"'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base 'div data-role="content"' args
        ∇
    :EndClass  ⍝ Content


    :Class ControlGroup0 : HtmlElement
        :field public readonly MyAttrs←'data-mini' 'data-type'
        :field public Legend←''

        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'div data-role="controlgroup"'
        ∇

        ∇ Make1 l
          :Access public
          :Implements constructor
          TAG←'div data-role="controlgroup"'
          Legend←l
        ∇

        ∇ Make2(l args)
          :Access public
          :Implements constructor :Base args
          TAG←'div data-role="controlgroup"'
          Legend←l
        ∇

        ∇ r←Render
          :Access public
          r←'legend'Enclose Legend
          r,←⎕BASE.Render
        ∇
    :EndClass  ⍝ ControlGroup



    :Class Enhancement : HtmlElement
        :Field public readonly MyAttrs←'data-enhance' 'data-ajax'
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'div data-enhance="none"'
        ∇
        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'div data-enhance="none"'
        ∇
    :EndClass  ⍝ Enhancement


    :section Lists

    :Class List : ItemList

        ∇ Make0
          :Access public
          :Implements constructor
          ItemClass←Li   ⍝ ItemClass is in ItemList
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          ItemClass←Li
        ∇
    :EndClass  ⍝ List

    :Class Ul : List
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'ul'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'ul'
        ∇
    :EndClass  ⍝ Ul

    :Class Ol : List
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'ol'
        ∇
        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'ol'
        ∇
    :EndClass  ⍝ Ol

    :Class Li : HtmlElement
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'li'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'li'
        ∇
    :EndClass

    :endsection ⍝ lists

    :Class Flip : HtmlElement
        :Field public readonly MyAttrs←'data-mini' 'data-theme' 'data-track-theme'
        :field public Options

        ∇ Make0
          :Access public
          :Implements constructor :Base 'select data-role="slider"'
        ∇
        ∇ Make1 id
          :Access public
          :Implements constructor :Base 'select data-role="slider"' '' ('id' id)
        ∇

        ∇ Make2(id opts)
          :Access public
          :Implements constructor :Base 'select data-role="slider"' '' ('id' id)
          Options←opts
        ∇

        ∇ Make3(id opts args)
          :Access public
          :Implements constructor :Base 'select data-role="slider"' '' args
          Attr'id'id
          Options←opts
        ∇

        ∇ r←Render
          :Access public
          InnerHTML←fmtOpts
          r←⎕BASE.Render
        ∇

        ∇ r←fmtOpts
          :If 2=≡Options
          :AndIf 1=⍴⍴Options
              r←↓2 2⍴(4÷⍴Options)/Options
          :Else
              r←↓Options
          :EndIf
          r←(⎕UCS 13 10),∊{'<option value="',(2⊃⍵),'">',(1⊃⍵),'</option>',⎕UCS 13 10}¨r
        ∇

    :EndClass


    :Class Footer : pageAnnotation

        ∇ Make0
          :Access public
          :Implements constructor :Base 'div data-role="footer"'
        ∇

        ∇ Make1 t
          :Access public
          :Implements constructor :Base 'div data-role="footer"'
          Title←t
        ∇
        ∇ Make2(t a)
          :Access public
          :Implements constructor :Base 'div data-role="footer"'
          Title←t
          Attr a
        ∇
    :EndClass



    :Class Header : pageAnnotation

        ∇ Make0
          :Access public
          :Implements constructor :Base 'div data-role="header"'
        ∇

        ∇ Make1 t
          :Access public
          :Implements constructor :Base 'div data-role="header"'
          Title←t
        ∇
        ∇ Make2(t a)
          :Access public
          :Implements constructor :Base 'div data-role="header"'
          Title←t
          Attr a
        ∇
    :EndClass

    :Class pageAnnotation : HtmlElement
        :Field public readonly MyAttrs ← 'data-id' 'data-position' 'data-fullscreen' 'data-theme'
        :Field public Left←''
        :field public Title←''
        :field public Right←''
        :field public HLevel←1

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
        ∇

        ∇ r←Render;t
          :Access public
          t←Title
          :If HLevel≠0
              t←('h',⍕HLevel)#.HTMLInput.Enclose Title
          :EndIf
          InnerHTML←''
          (Add Left).(Add t).Add Right
          r←⎕BASE.Render
        ∇
    :endclass

    :Class Link : HtmlElement
        :Field public readonly MyAttrs←'data-ajax' 'data-direction' 'data-dom-cache' 'data-prefetch' 'data-rel' 'data-transition' 'data-icon'

        ∇ Make0
          :Access public
          :Implements constructor :Base (,'a')
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base (⊂,'a'),eis args
        ∇
    :EndClass


    :Class Listview : ItemList  ⍝?
        :Field public readonly MyAttrs ← 'data-autodividers' 'data-count-theme' 'data-divider-theme' 'data-filter' 'data-filter-placeholder' 'data-filter-theme' 'data-header-theme' 'data-inset' 'data-split-icon' 'data-split-theme' 'data-theme'
        :Field public Numbered ← 0
        ∇ Make0
          :Access public
          :Implements constructor :Base
          Attr'data-role' 'listview'
          ItemClass←ListviewItem ⍝ this is a class
        ∇

        ∇ r←Render
          :Access Public
          TAG←(1+Numbered)⊃'ul' 'ol'
          r←⎕BASE.Render
        ∇

        ∇ AddRO html;inst
          :Access Public
        ⍝ Adds a read only list item
          Add ListviewItem html
        ∇

        ∇ AddLink args;inst;setattrs;url;html
        ⍝ Adds a read only list item
          :Access Public
          args←eis args
          html url setattrs←args,(3-⍴args)↑''
          inst←Add LinkListviewItem
          inst.url←url
          inst.Text←html
          inst.setattrs←setattrs
        ∇

        ∇ AddSplit ⍝?
        ∇
    :EndClass


    :Class ListviewItem : HtmlElement
        :Field  public readonly MyAttrs←'data-filtertext' 'data-icon' 'data-theme'
        ∇ Make0
          :Access public
          :Implements constructor :Base
          TAG←'li'
        ∇
        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'li'
        ∇
        ∇ r←Render
          r←⎕BASE.Render
        ∇
    :EndClass

    :Class LinkListviewItem : ListviewItem          ⍝?
        :Field public URL
        :Field public Text
        :Field public SetAttrs

        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'li'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'li'
        ∇


        ∇ r←Render
          InnerHTML←Add #.JQM.a Text('href'URL,SetAttrs)
          r←⎕BASE.Render
        ∇

    :EndClass


    :Class SplitListviewItem : ListviewItem

        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'li'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'li'
        ∇

        ∇ Make2(linkargs args)
          :Access public
          :Implements constructor :Base args
          TAG←'li'
          Add¨eis linkargs
        ∇

        ∇ r←Render       ⍝ no need
          r←⎕BASE.Render
        ∇
    :EndClass


    :Class ListViewLink : ListviewItem
        :Field public Thumb←''
        :Field public Icon←''
        :Field public AltText←''

        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'li'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'li'
        ∇

        ∇ Make2(linkargs args)
          :Access public
          :Implements constructor :Base args
          TAG←'li'
        ∇

        ∇ r←Render;ind
          :If ×ind←{⌈/1 2×~0∊∘⍴¨⍵}Thumb Icon
              #.HTMLInput.Tag'img src="',(Thumb Icon)[ind],'"',((~0∊⍴AltText)/' alt="',AltText,'"'),((2=ind)/' class="ui-li-icon"')
          :EndIf
          r←⎕BASE.Render
        ∇
    :EndClass

    :Class ListListviewItem : ListviewItem

        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'li'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'li'
        ∇

        ∇ Make2(linkargs args)
          :Access public
          :Implements constructor :Base args
          TAG←'li'
        ∇

        ∇ r←Render
          InnerHTML←Add #.JQM.a Text('href'URL,attrs)  ⍝ #. ???
          r←⎕BASE.Render
        ∇
    :EndClass




    :Class Navbar : ItemList
        :Field public readonly MyAttrs←'data-iconpos' 'data-theme'
        ∇ Make0
          :Access public
          :Implements constructor :Base
          TAG←'div data-role="navbar"'
          ItemClass←NavbarItem  ⍝ this is a class
        ∇


        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'div data-role="navbar"'
          ItemClass←NavbarItem
        ∇

        ∇ r←Render
          :Access Public
          InnerHTML←'ul'#.HTMLInput.Enclose Items.Render
          Items←''
          r←⎕BASE.Render
        ∇

        ∇ AddTo(url cont)
          :Access Public
          ⎕BASE.AddTo''
          ((⍴Items)⊃Items).(Href Text)←url cont
        ∇
    :EndClass

    :Class NavbarItem : HtmlElement
        :Field public Href←'#'
        :Field public Text←''

        ∇ Make0
          :Access public
          :Implements constructor :Base
          TAG←'a'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'a'
        ∇

        ∇ Make2(url content args)
          :Access public
          :Implements constructor :Base args
          TAG←'a'
          Href Text←url content
        ∇

        ∇ r←Render
          :Access Public
          Attr('href'Href)
          InnerHTML←Text
          r←⎕BASE.Render
          r←'li'#.HTMLInput.Enclose r
        ∇
    :EndClass


    :Class Radio : HtmlElement
    ⍝ Pairs of labels and inputs with type="radio" are auto-enhanced, no data-role required.
    ⍝ Multiple radio buttons can be wrapped in a container with a data-role="controlgroup" attribute for a vertically grouped set.
    ⍝ Add the data-type="horizontal" attribute for the radio buttons to sit side-by-side.
    ⍝ Add the data-mini="true" to get the mini/compact sized version for all the radio buttons that appear in the controlgroup.
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'input type="radio"'
        ∇
        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'input type="radio"'
        ∇
    :EndClass

    :Class Select : ItemList
    ⍝ All select form elements are auto-enhanced, no data-role required
        :Field public readonly MyAttrs←'data-icon' 'data-iconpos' 'data-inline' 'data-mini'  'data-role' 'data-placeholder' 'data-overlay-theme'  'data-native-menu'
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'select'
          ItemClass←Option  ⍝ Option is a class
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'select'
          ItemClass←Option
        ∇

    :EndClass

    :Class Option : HtmlElement
    ⍝ All select form elements are auto-enhanced, no data-role required
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'option'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'option'
        ∇
    :EndClass

    :Class ItemList : HtmlElement
        :Field public Items←''
        :Field public ItemClass
        ∇ AddTo args
          :Access Public
          Items,←Add ItemClass args
        ∇

        ∇ r←Render
          :Access Public
          :If ~0∊⍴Items
              InnerHTML←Items
          :EndIf
          r←⎕BASE.Render
        ∇
    :EndClass

    :Class Slider : HtmlElement
        :Field public readonly MyAttrs←'data-highlight' 'data-mini' 'data-track-theme' 'data-theme' 'data-role'
        :field public Value←1
        :field public Min←1
        :field public Max←100
        :field public Step←5

        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'input type="range"'
        ∇

        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'input type="range"'
        ∇

        ∇ r←Render
          :Access public
          Value Min Max Step AddAttr'value' 'min' 'max' 'step'
          r←⎕BASE.Render
        ∇
    :EndClass



    :Class Text : HtmlElement
        :Field public readonly MyAttrs←'data-mini' 'data-role' 'data-theme'
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'input type="text"'
        ∇

        ∇ Make1 Type
          :Access public
          :Implements constructor
          TAG←'input type="',Type,'"'
        ∇

        ∇ Make2(Type args)
          :Access public
          :Implements constructor :Base args
          TAG←'input type="',Type,'"'
        ∇
    :EndClass



    :Class Textarea : HtmlElement
        :Field public readonly MyAttrs←'data-mini' 'data-role' 'data-theme'
        ∇ Make0
          :Access public
          :Implements constructor
          TAG←'textarea'
        ∇
        ∇ Make1 args
          :Access public
          :Implements constructor :Base args
          TAG←'textarea'
        ∇
    :EndClass

    ∇ test;p
      p←Create ⎕NEW #.HTTPRequest('' '')
      p.AddPage'Page 1'
      ≡p.Render
     
    ∇
:EndNamespace