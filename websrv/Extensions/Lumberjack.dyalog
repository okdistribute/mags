:Class Lumberjack ⍝ it's a logger

    ⎕ML←1

    :property Active                    ⍝ external switch
    :access public instance
        ∇ r←get
          r←_active
        ∇
        ∇ set pa;v
          v←pa.NewValue
          ⎕SIGNAL 11/⍨(1=×/⍴v)⍲∧/v∊0 1 ⍝ single 1 or 0?
          v←⊃v
          :Select 2⊥v,_tid∊⎕TNUMS
          :Case 0       ⍝ not active, and no thread running
              _active←0
          :Case 1       ⍝ not active, thread running - stop
              :Trap 0
                  ⎕TKILL _tid
                  :If Open
                      ClearCache
                      Close
                  :EndIf
              :EndTrap
              _active←0
          :Case 2      ⍝ active, no thread running - start
              _tid←Run&0 ⋄ _active←1
          :Case 3      ⍝ active and already running
              _active←1
          :EndSelect
        ∇
    :endproperty


    :field public instance Directory←'' ⍝ directory to contain the log files
    :field public instance Interval←10  ⍝ write cache interval in seconds
    :field public instance Prefix←''    ⍝ prefix for the log files
    :field public instance EOL          ⍝ End Of Line

    :field private instance _active←0   ⍝ internal switch
    :field private instance _tieNo←⍬     ⍝ tie number for the current log file
    :field private instance _cache←''    ⍝ cached log records
    :field private instance _tid←¯1      ⍝ thread ID for the logging task

    missing←{0∊⍴⍵:'-' ⋄ ⍵}
    isWin←('.' ⎕WG 'APLVersion')[3]≡⊂,'W'
    eis←{2>|≡⍵:,⊂⍵ ⋄ ⍵} ⍝ Enclose if simple
    currentDir←{(1-⌊/'/\'⍳⍨⌽⍵)↓⍵}⎕WSID
    tonum←{w←⍵⋄((w='-')/w)←'¯'⋄2 1⊃⎕VFI w}

    ∇ Make0
      :Access public
      :Implements constructor
      EOL←⎕UCS 13 10↓⍨~isWin
    ∇

    ∇ Make pars;file;log;active
      :Access public
      :Implements Constructor
      ⍝ load logger information
      Active←0
      EOL←⎕UCS 13 10↓⍨~isWin
      pars←eis pars
      (Directory active Prefix Interval)←4↑pars,(⍴pars)↓currentDir 0 '' 10
      ('Log file directory "',Directory,'" not found!')⎕SIGNAL 11/⍨~#.Files.DirExists Directory
      Active←active
    ∇

    ∇ UnMake
      :Implements destructor
      Active←0
    ∇

    ∇ Stop
      :Access public
      Active←0
    ∇

    ∇ Start
      :Access public
      Active←1
    ∇

    ∇ Run x;done
      :While Active
          {}⎕DL Interval
          :If Open
              ClearCache
              Close
          :EndIf
      :EndWhile
    ∇


    ∇ r←Open;fn
      r←0
      :Trap 6
          fn←#.Files.unixfix Directory,Prefix,(⍕100⊥3↑⎕TS),'.log'
      :Else
          →0
      :EndTrap
     
      :Trap 22 ⍝ file name error
          _tieNo←fn ⎕NTIE 0 34
      :Else
          :Trap 0
              ⎕NUNTIE fn ⎕NCREATE 0
              _tieNo←fn ⎕NTIE 0 34
          :Else
              ⎕←'Unable to open log file "',fn,'"'
              :Return
          :EndTrap
      :EndTrap
      r←0≠_tieNo
    ∇

    ∇ {flags}Log record
      ⍝ Append a log record to the cache
      ⍝ flags - [1] Prepend timestamp [2] Append EOL
      ⍝ record - data to write to log
      :Access public
      :If Active
          flags←{6::0 0 ⋄ 2↑flags}⍬
          :Hold 'Lumberjack',⍕_tid
              _cache,←(Now flags[1]),record,flags[2]/EOL
          :EndHold
      :EndIf
    ∇

    ∇ r←Now flag
      :Access public
      r←''
      →flag↓0
      r←,'ZI4,<->,ZI2,<->,ZI2,<@>,ZI2,<:>,ZI2,<:>,ZI2,<.>,ZI3,< >'⎕FMT 1 7⍴⎕TS
    ∇

    ∇ ClearCache
      :Hold 'Lumberjack',⍕_tid
          _cache ⎕NAPPEND _tieNo
          _cache←''
      :EndHold
    ∇

    ∇ Close
      ⎕NUNTIE _tieNo
    ∇

    ∇ r←ns Setting pars;name;num;default;mask
    ⍝ returns setting from a config style namespace or provides a default if it doesn't exist
    ⍝ pars - name [num] [default]
    ⍝ ns - namespace reference
    ⍝ name - name of the setting
    ⍝ num - 1 if setting is numeric, 0 otherwise
    ⍝ default - default value if not found
      pars←eis pars
      name num←2↑pars,(⍴pars)↓'' 0 ''
      :If 2<⍴pars ⋄ default←3⊃pars
      :Else ⋄ default←(1+num)⊃''⍬
      :EndIf
      r←(⍴ns)⍴⊂default
      :If ∨/mask←0≠⊃¨ns.⎕NC⊂name
          (mask/r)←(tonum⍣num)¨(mask/ns).⍎⊂name
      :EndIf
      :If 0=⍴⍴r ⋄ r←⊃r ⋄ :EndIf
    ∇

:EndClass