:Namespace HTTPClient
⍝ === VARIABLES ===

NL←(⎕ucs 13 10)

_←⍬
_,←'# This file contains port numbers for well-known services defined by IANA' (,'#') '# Format:' (,'#')
_,←'# <service name>  <port number>/<protocol>  [aliases...]   [#<comment>]' (,'#') ''
_,←'echo                7/tcp' 'echo                7/udp' 'discard             9/tcp    sink null'
_,←,⊂'discard             9/udp    sink null'
_,←,⊂'systat             11/tcp    users                  #Active users'
_,←'systat             11/tcp    users                  #Active users' 'daytime            13/tcp'
_,←'daytime            13/udp' 'qotd               17/tcp    quote                  #Quote of the day'
_,←,⊂'qotd               17/udp    quote                  #Quote of the day'
_,←,⊂'chargen            19/tcp    ttytst source          #Character generator'
_,←,⊂'chargen            19/udp    ttytst source          #Character generator'
_,←,⊂'ftp-data           20/tcp                           #FTP, data'
_,←'ftp                21/tcp                           #FTP. control' 'telnet             23/tcp'
_,←,⊂'smtp               25/tcp    mail                   #Simple Mail Transfer Protocol'
_,←'time               37/tcp    timserver' 'time               37/udp    timserver'
_,←,⊂'rlp                39/udp    resource               #Resource Location Protocol'
_,←,⊂'nameserver         42/tcp    name                   #Host Name Server'
_,←,⊂'nameserver         42/udp    name                   #Host Name Server'
_,←,⊂'nicname            43/tcp    whois'
_,←,⊂'domain             53/tcp                           #Domain Name Server'
_,←,⊂'domain             53/udp                           #Domain Name Server'
_,←,⊂'bootps             67/udp    dhcps                  #Bootstrap Protocol Server'
_,←,⊂'bootpc             68/udp    dhcpc                  #Bootstrap Protocol Client'
_,←,⊂'tftp               69/udp                           #Trivial File Transfer'
_,←'gopher             70/tcp' 'finger             79/tcp'
_,←,⊂'http               80/tcp    www www-http           #World Wide Web'
_,←,⊂'kerberos           88/tcp    krb5 kerberos-sec      #Kerberos'
_,←,⊂'kerberos           88/udp    krb5 kerberos-sec      #Kerberos'
_,←,⊂'hostname          101/tcp    hostnames              #NIC Host Name Server'
_,←,⊂'iso-tsap          102/tcp                           #ISO-TSAP Class 0'
_,←,⊂'rtelnet           107/tcp                           #Remote Telnet Service'
_,←,⊂'pop2              109/tcp    postoffice             #Post Office Protocol - Version 2'
_,←,⊂'pop3              110/tcp                           #Post Office Protocol - Version 3'
_,←,⊂'sunrpc            111/tcp    rpcbind portmap        #SUN Remote Procedure Call'
_,←,⊂'sunrpc            111/udp    rpcbind portmap        #SUN Remote Procedure Call'
_,←,⊂'auth              113/tcp    ident tap              #Identification Protocol'
_,←,⊂'uucp-path         117/tcp'
_,←,⊂'nntp              119/tcp    usenet                 #Network News Transfer Protocol'
_,←,⊂'ntp               123/udp                           #Network Time Protocol'
_,←,⊂'epmap             135/tcp    loc-srv                #DCE endpoint resolution'
_,←,⊂'epmap             135/udp    loc-srv                #DCE endpoint resolution'
_,←,⊂'netbios-ns        137/tcp    nbname                 #NETBIOS Name Service'
_,←,⊂'netbios-ns        137/udp    nbname                 #NETBIOS Name Service'
_,←,⊂'netbios-dgm       138/udp    nbdatagram             #NETBIOS Datagram Service'
_,←,⊂'netbios-ssn       139/tcp    nbsession              #NETBIOS Session Service'
_,←,⊂'imap              143/tcp    imap4                  #Internet Message Access Protocol'
_,←,⊂'pcmail-srv        158/tcp                           #PCMail Server'
_,←,⊂'snmp              161/udp                           #SNMP'
_,←,⊂'snmptrap          162/udp    snmp-trap              #SNMP trap'
_,←,⊂'print-srv         170/tcp                           #Network PostScript'
_,←,⊂'bgp               179/tcp                           #Border Gateway Protocol'
_,←,⊂'irc               194/tcp                           #Internet Relay Chat Protocol        '
_,←,⊂'ipx               213/udp                           #IPX over IP'
_,←,⊂'ldap              389/tcp                           #Lightweight Directory Access Protocol'
_,←'https             443/tcp    MCom' 'https             443/udp    MCom' 'microsoft-ds      445/tcp'
_,←'microsoft-ds      445/udp' 'kpasswd           464/tcp                           # Kerberos (v5)'
_,←,⊂'kpasswd           464/udp                           # Kerberos (v5)'
_,←,⊂'isakmp            500/udp    ike                    #Internet Key Exchange'
_,←,⊂'exec              512/tcp                           #Remote Process Execution'
_,←,⊂'biff              512/udp    comsat'
_,←,⊂'login             513/tcp                           #Remote Login'
_,←'who               513/udp    whod' 'cmd               514/tcp    shell' 'syslog            514/udp'
_,←'printer           515/tcp    spooler' 'talk              517/udp' 'ntalk             518/udp'
_,←,⊂'efs               520/tcp                           #Extended File Name Server'
_,←'router            520/udp    route routed' 'timed             525/udp    timeserver'
_,←'tempo             526/tcp    newdate' 'courier           530/tcp    rpc'
_,←'conference        531/tcp    chat' 'netnews           532/tcp    readnews'
_,←,⊂'netwall           533/udp                           #For emergency broadcasts'
_,←,⊂'uucp              540/tcp    uucpd'
_,←,⊂'klogin            543/tcp                           #Kerberos login'
_,←,⊂'kshell            544/tcp    krcmd                  #Kerberos remote shell'
_,←'new-rwho          550/udp    new-who' 'remotefs          556/tcp    rfs rfs_server'
_,←'rmonitor          560/udp    rmonitord' 'monitor           561/udp'
_,←,⊂'ldaps             636/tcp    sldap                  #LDAP over TLS/SSL'
_,←,⊂'doom              666/tcp                           #Doom Id Software'
_,←,⊂'doom              666/udp                           #Doom Id Software'
_,←,⊂'kerberos-adm      749/tcp                           #Kerberos administration'
_,←,⊂'kerberos-adm      749/udp                           #Kerberos administration'
_,←,⊂'kerberos-iv       750/udp                           #Kerberos version IV'
_,←,⊂'kpop             1109/tcp                           #Kerberos POP'
_,←,⊂'phone            1167/udp                           #Conference calling'
_,←,⊂'ms-sql-s         1433/tcp                           #Microsoft-SQL-Server '
_,←,⊂'ms-sql-s         1433/udp                           #Microsoft-SQL-Server '
_,←,⊂'ms-sql-m         1434/tcp                           #Microsoft-SQL-Monitor'
_,←,⊂'ms-sql-m         1434/udp                           #Microsoft-SQL-Monitor                '
_,←,⊂'wins             1512/tcp                           #Microsoft Windows Internet Name Service'
_,←,⊂'wins             1512/udp                           #Microsoft Windows Internet Name Service'
_,←,⊂'ingreslock       1524/tcp    ingres'
_,←,⊂'l2tp             1701/udp                           #Layer Two Tunneling Protocol'
_,←,⊂'pptp             1723/tcp                           #Point-to-point tunnelling protocol'
_,←,⊂'radius           1812/udp                           #RADIUS authentication protocol'
_,←,⊂'radacct          1813/udp                           #RADIUS accounting protocol'
_,←,⊂'nfsd             2049/udp    nfs                    #NFS server'
_,←,⊂'knetd            2053/tcp                           #Kerberos de-multiplexor'
_,←'man              9535/tcp                           #Remote Man Server' ''
Services←_

⎕ex '_'

⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX←1 0 3

∇ r←CertPath;droptail;exists;file;ws
     ⍝ Return the path to the certificates
     
 file←'server/localhost-server-cert.pem' ⍝ Search for this file
 droptail←{(-⌊/(⌽⍵)⍳'\/')↓⍵}
 exists←{0::0 ⋄ 1{⍺}⎕NUNTIE ⍵ ⎕NTIE 0}
     
 :If exists(r←{⍵,('/'≠¯1↑⍵)/'/'}{(-'\'=¯1↑⍵)↓⍵}TestCertificates),file
 :ElseIf exists(r←'/TestCertificates/',⍨ws←droptail ⎕WSID),file
 :ElseIf exists(r←'/TestCertificates/',⍨ws←droptail ws),file
 :ElseIf exists(r←'../TestCertificates/'),file
 :Else
     ('Unable to locate file ',file)⎕SIGNAL 22
 :EndIf
∇


∇ user←GetUserFromCerts cert;user
     
 :If 0≠⍴cert
     user←(⊃cert).Formatted.(Subject Issuer)
     ⍝user←'CN'∘{⊃⍵[⍵[;1]⍳⊂⍺;2]}¨cert
     ⍝user←(1⊃user)(1↓,⍕'/',¨1↓user)
 :Else ⋄ user←'UNKNOWN' 'UNKNOWN'
 :EndIf
 user←'User' 'C.A.',[1.5]user
∇

∇ r←{certs}HTTPGet url;U;DRC;protocol;wr;key;flags;pars;secure;data;z;header;datalen;host;port;done;cmd;b;page;auth;p;x509;priority;err;req;fromutf8
     ⍝ Get an HTTP page, format [HTTP[S]://][user:pass@]url[:port][/page]
     ⍝ Opional Left argument: PublicCert PrivateKey SSLValidation
     ⍝ Makes secure connection if left arg provided or URL begins with https:
     
     ⍝ Result: (return code) (HTTP headers) (HTTP body) [PeerCert if secure]
     
 (U DRC)←#.(HTTPUtils DRC) ⍝ Uses utils from here
 fromutf8←{0::(⎕AV,'?')[⎕AVU⍳⍵] ⋄ 'UTF-8'⎕UCS ⍵} ⍝ Turn raw UTF-8 input into text
     
 {}DRC.Init''
     
 p←(∨/b)×1+(b←'//'⍷url)⍳1
 secure←(2=⎕NC'certs')∨(U.lc(p-2)↑url)≡'https:'
 port←(1+secure)⊃80 443 ⍝ Default HTTP/HTTPS port
 url←p↓url              ⍝ Remove HTTP[s]:// if present
 host page←'/'split url,(~'/'∊url)/'/'    ⍝ Extract host and page from url
     
 :If 0=⎕NC'certs' ⋄ certs←'' ⋄ :EndIf
     
 :If secure
     x509 flags priority←3↑certs,(⍴,certs)↓(⎕NEW ##.DRC.X509Cert)32 'NORMAL:!CTYPE-OPENPGP'  ⍝ 32=Do not validate Certs
     pars←('x509'x509)('SSLValidation'flags)('Priority'priority)
 :Else ⋄ pars←''
 :EndIf
     
 :If '@'∊host ⍝ Handle user:password@host...
     auth←NL,'Authorization: Basic ',(U.Encode(¯1+p←host⍳'@')↑host)
     host←p↓host
 :Else ⋄ auth←''
 :EndIf
     
 host port←port U.HostPort host ⍝ Check for override of port number
     
 req←'GET ',page,' HTTP/1.1',NL,'Host: ',host,NL,'User-Agent: Dyalog/Conga',NL,'Accept: */*',auth,NL ⍝ build the request
     
 :If DRC.flate.IsAvailable ⍝ if compression is available
     req,←'Accept-Encoding: deflate',NL ⍝ indicate we can accept it
 :EndIf
     
 :If 0=⊃(err cmd)←2↑r←DRC.Clt''host port'Text' 100000,pars ⍝ 100,000 is max receive buffer size
 :AndIf 0=⊃r←DRC.Send cmd(req,NL)
     
     done data header←0 ⍬(0 ⍬)
     
     :Repeat
         :If ~done←0≠1⊃wr←DRC.Wait cmd 5000            ⍝ Wait up to 5 secs
     
             :If wr[3]∊'Block' 'BlockLast'                ⍝ If we got some data
                 :If 0<⍴data,←4⊃wr
                 :AndIf 0=1⊃header
                     header←U.DecodeHeader data
                     :If 0<1⊃header
                         data←(1⊃header)↓data
                         datalen←⊃((2⊃header)U.GetValue'Content-Length' 'Numeric'),¯1 ⍝ ¯1 if no content length not specified
                     :EndIf
                 :EndIf
             :Else
                 ⎕←wr ⍝ Error?
                 ∘
             :EndIf
     
             done←'BlockLast'≡3⊃wr                        ⍝ Done if socket was closed
             :If datalen>0
                 done←done∨datalen≤⍴data ⍝ ... or if declared amount of data rcvd
             :Else
                 done←done∨(∨/'</html>'⍷data)∨(∨/'</HTML>'⍷data)
             :EndIf
         :EndIf
     :Until done
     
     :Trap 0 ⍝ If any errors occur, abandon conversion
         :If ∨/'deflate'⍷(2⊃header)U.GetValue'content-encoding' '' ⍝ was the response compressed?
             data←fromutf8 DRC.flate.Inflate 120 156,256|83 ⎕DR data ⍝ append 120 156 signature because web servers strip it out due to IE
         :ElseIf ∨/'charset=utf-8'⍷(2⊃header)U.GetValue'content-type' ''
             data←'UTF-8'⎕UCS ⎕UCS data ⍝ Convert from UTF-8
         :EndIf
     :EndTrap
     
     r←(1⊃wr)(2⊃header)data
     :If secure ⋄ r←r,⊂DRC.GetProp cmd'PeerCert' ⋄ :EndIf
 :Else
     'Connection failed ',,⍕r
 :EndIf
     
 z←DRC.Close cmd
∇

∇ cert←ReadCert relfilename;certpath;fn
 ss←{⎕ML←1                           ⍝ Approx alternative to xutils' ss.
     srce find repl←,¨⍵              ⍝ source, find and replace vectors.
     mask←find⍷srce                  ⍝ mask of matching strings.
     prem←(⍴find)↑1                  ⍝ leading pre-mask.
     cvex←(prem,mask)⊂find,srce      ⍝ partitioned at find points.
     (⍴repl)↓∊{repl,(⍴find)↓⍵}¨cvex  ⍝ collected with replacements.
 }
 certpath←CertPath
 fn←certpath,relfilename,'-cert.pem'
 cert←⊃##.DRC.X509Cert.ReadCertFromFile fn
 cert.KeyOrigin←{(1⊃⍵)(ss(2⊃⍵)'-cert' '-key')}cert.CertOrigin
∇


 split←{(p↑⍵)((p←¯1+⍵⍳⍺)↓⍵)}

 Cert←{(⍺.Cert)⍺⍺ ⍵.Cert}


:EndNamespace 
