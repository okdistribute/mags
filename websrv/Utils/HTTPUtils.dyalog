:Namespace HTTPUtils
⍝ === VARIABLES ===

NL←(⎕ucs 13 10)


⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX←1 0 3

∇ HTTPCmd←DecodeCmd req;split;buf;input;args;z
     ⍝ Decode an HTTP command line: get /page&arg1=x&arg2=y
     ⍝ Return namespace containing:
     ⍝ Command: HTTP Command ('get' or 'post')
     ⍝ Headers: HTTP Headers as 2 column matrix or name/value pairs
     ⍝ Page:    Requested page
     ⍝ Arguments: Arguments to the command (cmd?arg1=value1&arg2=value2) as 2 column matrix of name/value pairs
     
 input←1⊃,req←2⊃##.HTTPUtils.DecodeHeader req
 'HTTPCmd'⎕NS'' ⍝ Make empty namespace
 HTTPCmd.Input←input
 HTTPCmd.Headers←{(0≠⊃∘⍴¨⍵[;1])⌿⍵}1 0↓req
     
 split←{p←(⍺⍷⍵)⍳1 ⋄ ((p-1)↑⍵)(p↓⍵)} ⍝ Split ⍵ on first occurrence of ⍺
     
 HTTPCmd.Command buf←' 'split input
 buf z←'http/'split buf
 HTTPCmd.Page args←'?'split buf
     
 HTTPCmd.Arguments←(args∨.≠' ')⌿↑'='∘split¨{1↓¨(⍵='&')⊂⍵}'&',args ⍝ Cut on '&'
∇

∇ r←DecodeHeader buf;len;d
     ⍝ Decode HTML Header
     
 len←(¯1+⍴NL,NL)+⊃{((NL,NL)⍷⍵)/⍳⍴⍵}buf
 :If len>0
     d←(⍴NL)↓¨{(NL⍷⍵)⊂⍵}NL,len↑buf
     d←↑{((p-1)↑⍵)((p←⍵⍳':')↓⍵)}¨d
     d[;1]←lc¨d[;1]
 :Else
     d←⍬
 :EndIf
 r←len d
∇

∇ code←Encode strg;raw;rows;cols;mat;alph
     ⍝ Base64 Encode
 raw←⊃,/11∘⎕DR¨strg
 cols←6
 rows←⌈(⊃⍴raw)÷cols
 mat←rows cols⍴(rows×cols)↑raw
 alph←'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 alph,←'abcdefghijklmnopqrstuvwxyz'
 alph,←'0123456789+/'
 code←alph[⎕IO+2⊥⍉mat],(4|-rows)⍴'='
∇

∇ r←header GetValue(name type);i;h
     ⍝ Extract value from HTTP Header structure returned by DecodeHeader
     
 :If (1↑⍴header)<i←header[;1]⍳⊂lc name
     r←⍬ ⍝ Not found
 :Else
     r←⊃header[i;2]
     :If 'Numeric'≡type
         r←1⊃2⊃⎕VFI r
     :EndIf
 :EndIf
∇

∇ r←port HostPort host;z
     ⍝ Split host from port
     
 :If (⍴host)≥z←host⍳':'
     port←1⊃2⊃⎕VFI z↓host ⋄ host←(z-1)↑host  ⍝ Use :port if found in host name
 :EndIf
     
 r←host port
∇

∇ r←{options}Table data;NL
     ⍝ Format an HTML Table
     
 NL←⎕AV[4 3]
 :If 0=⎕NC'options' ⋄ options←'' ⋄ :EndIf
     
 r←,∘⍕¨data                     ⍝ make strings
 r←,/(⊂'<td>'),¨r,¨⊂'</td>'     ⍝ enclose cells to make rows
 r←⊃,/(⊂'<tr>'),¨r,¨⊂'</tr>',NL ⍝ enclose table rows
 r←'<table ',options,'>',r,'</table>'
∇

∇ r←lc x;t
 t←⎕AV ⋄ t[⎕AV⍳⎕A]←'abcdefghijklmnopqrstuvwxyz'
 r←t[⎕AV⍳x]
∇

:EndNamespace 