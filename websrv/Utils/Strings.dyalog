:Namespace Strings

    ∇ r←lc r;m;upper
      lower←'abcdefghijklmnopqrstuvwxyzæøå'
      m←r∊upper←⎕A,'ÆØÅ'
      (m/r)←lower[upper⍳m/r]
    ∇
       
    ∇ r←{sep}vtom x;max;len;m
    ⍝ Vector to Matrix with optional separator
      :If 0=⎕NC'sep' ⋄ sep←' ' ⋄ :EndIf
      max←⌈/len←¯1+{(⍵,1+⍴x)-0,⍵}{⍵/⍳⍴⍵}sep=x←,x
      r←((0≠⍴x)×⍴m)⍴(,m←len∘.≥⍳max)\,x~' '
    ∇
    
    ∇ r←dlb x
    ⍝ Delete Leading Blanks
      r←(+/∧\' '=x)↓x
    ∇
    
    ∇ r←dtb x
    ⍝ Delete Trailing Blanks
      r←(-+/∧\' '=⌽x)↓x
    ∇
    
    ∇ r←dmb x;m
    ⍝ Delete multiple blanks
      r←(m⍲1⌽m←' '=x)/x
    ∇

    ∇ str←str subst(from to);m;⎕IO;i
    ⍝ simple string substitution
      ⎕IO←0
      :Trap 0
          str←((esc from)⎕R(esc to))str
      :Else
          →(∨/m←from⍷str)↓0
          i←m⍳1
          str←((i↑str),to,(i+⍴from)↓str)subst(from to)
      :EndTrap
    ∇

    esc←{⎕ML←1 ⋄ m←∊(-1+⍵∊'%\')↑¨1 ⋄ r←m\⍵ ⋄ ((~m)/r)←'\' ⋄ r }

:EndNamespace