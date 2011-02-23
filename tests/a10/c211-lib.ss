; Oscar's draw-tree.ss, modified by Suzanne Menzel, to include a tree ADT 
; and a draw-tree that converts the external representation to the
; internal tnode record representation.

; Oscar's original notes:
; Use (draw-tree <tnode>) to draw a graphical depiction of a the given
; binary tree in SWL.  The draw-tree procedure expects a binary tree
; whose interior nodes are represented by tnode records defined by:
;   (define-record tnode (data left right))
; The empty tree is represented by the empty list.
;
; tnode records are drawn as ovals containing labelled with a printed
; representation of the tnode-data.
; Other values are drawn as rectangles labelled with a printed
; representation of the value.
;
; After a tree has been drawn, you can hilight a tnode using:
;   (show-node <tnode>)
; or
;   (show-node <tnode> <format-string> <args...>)
; Both forms draw the node with a thicker outline.
; The second form permits an optional printf-style format string and
; optional arguments.
;
; Execution of the program is suspended while the node is hilighted.
; The parameter (show-node-delay) determines how long the node remains
; highlighted.  If the delay is #f, the node remains hilighted until
; you click the "Next" button.  Otherwise the delay is expected to be
; a nonnegative integer specifying the number of milliseconds to delay
; before continuing.
;
; You can use (mark-node <tnode> <color>) to set the color of a node
; and (node-color <tnode>) to get the color of a node.
; Colors can be specified as symbols, e.g., 'red, 'blue, 'yellow, etc.
;
; You can use (show-result <tnode> <value>) to trace the returns from
; the recursive call that started at <tnode>.  Just use the recursive
; call as the second argument.  show-result returns <value>.
; This is a simple macro implemented in terms of show-node and mark-node.

(let-syntax ([once
              (lambda (x)
                (if (getprop '*draw-tree* 'loaded #f)
                    #'(void)
                    (begin
                      (putprop '*draw-tree* 'loaded #t)
                      (syntax-case x () [(_ e) #'e]))))])
(once
(module (draw-tree show-node show-result show-node-delay mark-node node-color
          ;; added ADT procedures (sm)
          empty-tree tree empty-tree? tree? root-value left-subtree right-subtree
          leaf? leaf)
  (import swl:oop)
  (import swl:macros)
  (import swl:option)
  (import swl:generics)
  (import swl:threads)

  (define border 5) ; space to leave around the entire diagram
  (define pad 2)    ; space around the text of a node label
  (define font-size 24)
  (define node-sep 24)
  (define canvas-size 300)

;  (define empty? null?)

  (define show-node-delay
    (make-parameter 1000
      (lambda (x)
        (unless (or (eq? x #f)
                    (and (integer? x) (exact? x) (not (negative? x))))
          (error 'show-node-delay
            "~s is not #f or an exact nonnegative integer" x))
        x)))

  (define labels '())

  (define show-node
    (lambda (tr . args)
      (let ([a (assq tr labels)])
        (when a (send (cdr a) show-node (show-node-delay) args)))))

  (define mark-node
    (lambda (tr color)
      (let ([a (assq tr labels)])
        (when a (send (cdr a) mark-node color)))))

  (define node-color
    (lambda (tr)
      (let ([a (assq tr labels)])
        (if a (send (cdr a) node-color) 'white))))

  (define-syntax show-result
   (syntax-rules ()
     [(show-result tr-exp value-exp)
      (let ([tr tr-exp])
        (let ([color (node-color tr)])
          (mark-node tr 'lightblue)
          (let ([result value-exp])
            (show-node tr "result = ~s" result)
            (mark-node tr color)
            result)))]))

  (define-record box (label))

  ;; defined the following internal record and tree ADT (sm)
  (define-record tnode (data left right)) 
  (define-record empty ())
  (define empty-tree
    (lambda ()
      (make-empty)))
  (define empty-tree? 
    (lambda (x) (empty? x)))
  (define tree 
    (lambda (data left right)
      (make-tnode data left right)))
  (define tree?
    (lambda (tr)
      (or (empty-tree? tr) (tnode? tr))))
  (define root-value
   (lambda (tr)
    (tnode-data tr)))
  (define left-subtree
   (lambda (tr)
    (tnode-left tr)))
  (define right-subtree
   (lambda (tr)
    (tnode-right tr)))
  (define leaf?
    (lambda (tr)
      (and (tree? tr)
           (not (empty-tree? tr))
           (empty-tree? (left-subtree tr))
           (empty-tree? (right-subtree tr)))))
  (define leaf
    (lambda (x)
      (tree x (empty-tree) (empty-tree))))

  (define draw-tree
    (lambda (tr)
     (define remls '())
(define treequal?
  (letrec ((check (lambda (t1 t2)
                    (cond
                     ((and (empty-tree? t1) (empty-tree? t2)) #t)
                     ((or (empty-tree? t1) (empty-tree? t2))  #f)
                     (else
                      (and (equal? (root-value t1) (root-value t2))
                           (check (left-subtree t1) (left-subtree t2))
                           (check (right-subtree t1) (right-subtree t2))))))))
    (lambda (v1 v2)
      (if (and (tree? v1) (tree? v2))
          (check v1 v2)
        #f))))
      
      ;; defined the following converter (sm)
      (define external->internal
        (lambda (tr)
          (if (not (tree? tr))
              tr
              (if (empty-tree? tr)
                  '()
                  (make-tnode (root-value tr)
                    (external->internal (left-subtree tr))
                    (external->internal (right-subtree tr)))))))
      
     (define make-canvas
       (lambda (sf delay-handler)
         (let ([canvas (create <canvas> sf with (background-color: 'white))]
               [font (create <font> 'courier font-size '())]
               [rank-height (* 3 font-size)])

           (module (make-label label-width label-height)

             (define-generic label-height)
             (define-generic label-width)

             (define-class (<annotation> c x y) (<canvas-text> c x y)
               (ivars [box #f])
               (inherited)
               (inheritable)
               (private)
               (protected)
               (public
                 [destroy ()
                  (when box (destroy box))
                  (send-base self destroy)]
                 [raise ()
                  (apply
                    (lambda (x1 y1 x2 y2)
                      (set! box
                        (create <rectangle> canvas (- x1 pad) (- y1 pad) (+ x2 pad) (+ y2 pad) with
                          (fill-color: 'yellow)
                          (line-thickness: 0)))
                      (send-base self raise))
                    (bounding-box self))]))

             (define-class (<tnode> c x y) (<canvas-text> c x y)
               (ivars [border #f] [live? #t] [shape 'oval])
               (inherited)
               (inheritable)
               (private
                 [bbox () (bounding-box self)]
                 [set-active! (flag) (set-line-thickness! border (if flag 4 1))]
                 [make-annotation (args)
                  (if (null? args)
                      #f
                      (let ([fmt (car args)] [rest (cdr args)])
                        (unless (string? fmt)
                          (error 'show-node "expected a printf-style format string, but found ~s" fmt))
                        (let ([xy (get-coords self)])
                          (let ([anno (create <annotation> canvas (+ (car xy) (* 2 pad) (label-width self)) (cadr xy) with
                                        (anchor: 'w)
                                        (font: font)
                                        (title:
                                          (let ([real-eh (error-handler)])
                                            (parameterize ([error-handler (lambda (x . args) (apply real-eh 'show-node args))])
                                              (apply format fmt rest)))))])
                            (send anno raise)
                            anno))))])
               (protected)
               (public
                 [label-width () (+ pad (apply (lambda (x1 y1 x2 y2) (- x2 x1)) (bbox)))]
                 [label-height () (+ pad (apply (lambda (x1 y1 x2 y2) (- y2 y1)) (bbox)))]
                 [set-coords! (x y)
                  (send-base self set-coords! x y)
                  (let ([w (label-width self)] [h (label-height self)])
                    (let ([xpad (+ pad (quotient (max h w) 2))]
                          [ypad (+ pad (quotient h 2))])
                      (let ([x1 (- x xpad)]
                            [y1 (- y ypad)]
                            [x2 (+ x xpad)]
                            [y2 (+ y ypad)])
                        (if (and border (case shape [(rectangle) (isa? border <rectangle>)] [(oval) (isa? border <oval>)] [else #f]))
                            (set-coords! border x1 y1 x2 y2)
                            (begin
                              (set! border
                                (case shape
                                  [(oval)
                                   (create <oval> canvas x1 y1 x2 y2 with
                                     (fill-color: 'white))]
                                  [(rectangle)
                                   (create <rectangle> canvas x1 y1 x2 y2 with
                                     (fill-color: 'white))]
                                  [else #f]))
                              (send self raise))))))]
                 [set-shape! (s)
                  (unless (memq s '(rectangle oval)) (error 'set-shape! "invalid shape ~s" s))
                  (set! shape s)
                  (apply set-coords! self (get-coords self))]
                 [destroy ()
                  (set! live? #f)
                  (send-base self destroy)]
                 [node-color ()
                  (if border (get-fill-color border) 'white)]
                 [mark-node (color)
                  (when border (set-fill-color! border color))]
                 [show-node (delay args)
                  (when border
                    (set-active! #t)
                    (let ([anno (make-annotation args)])
                      (delay-handler delay)
                      (critical-section
                        (when live? (when anno (destroy anno)))))
                    (critical-section (when live? (set-active! #f))))]))

             (define make-label
               (lambda (tr)
                 (let ([text
                        (format "~s"
                          (if (box? (tnode-data tr))
                              (box-label (tnode-data tr))
                              (tnode-data tr)))])
                   (let ([lab
                          (create <tnode> canvas -100 -100 with
                            (shape: (if (box? (tnode-data tr)) 'rectangle 'oval))
                            (font: font)
                            (title: text))])
                     (critical-section (set! labels (cons (cons tr lab) labels)))
                     (set! remls (cons lab remls))
                     lab))))

           )

           (define draw-tree
             (lambda (tr offset y)
               (if (not (tnode? tr))
                   (if (null? tr)
                       (values #f 0 0)
                       (draw-tree (make-tnode (make-box tr) '() '()) offset y)) ; make expression trees into ordinary trees
                   (let ([y2 (+ y rank-height)])
                     (let-values ([(x1 w1 d1) (draw-tree (tnode-left tr) offset y2)])
                       (let ([offset (+ offset w1 node-sep)])
                         (let-values ([(x2 w2 d2) (draw-tree (tnode-right tr) offset y2)]
                                      [(lab) (make-label tr)])
                           (let ([x
                                  (cond
                                    [(and x1 x2) (/ (+ x1 x2) 2.0)]
                                    [x1 (+ x1 node-sep)]
                                    [x2 (- x2 node-sep)]
                                    [else (+ offset (quotient (label-width lab) 2))])])
                             (set-coords! lab x y)
                             (when x1 (send (create <line> canvas x y x1 y2) lower))
                             (when x2 (send (create <line> canvas x y x2 y2) lower))
                             (values x
                               (max (if (or x1 x2) (+ w1 w2 node-sep) 0)
                                    (label-width lab))
                               (+ 1 (max d1 d2)))))))))))

           (let-values ([(ignore w d) 
                         (draw-tree (external->internal tr) ;; applied the converter (sm) 
                           border (quotient rank-height 2))])
             (set-scroll-region! canvas 0 0 (+ w (* 2 node-sep)) (* d rank-height)))
           canvas)))
      ;; quoted the following test (sm)
     '(for-each
       (lambda (s)
         (unless (and (top-level-bound? s) (procedure? (top-level-value s)))
           (error #f "~s is not defined as expected, have you defined the tnode record type?" s)))
       '(tnode? make-tnode tnode-left tnode-right tnode-data))
     (let* ([q (thread-make-msg-queue 'next)]
            [top
             (create <toplevel> with
               (title: "Tree View")
               (width: canvas-size)
               (height: canvas-size)
               (destroy-request-handler:
                 (lambda (top)
                   (critical-section
                     (set! labels
                       (let f ([ls labels] [new '()])
                         (if (null? ls)
                             new
                             (f (cdr ls)
                                (if (memq (cdar ls) remls)
                                    new
                                    (cons (car ls) new)))))))
                   (thread-send-msg q 'destroy)
                   #t)))]
            [tf (create <frame> top)]
            [next (create <button> tf with
                    (title: "Next")
                    (action: (lambda (b) (thread-send-msg q #t))))]
            [sf
             (create <scrollframe> top with
               (sticky-hscroll: #t)
               (default-vscroll: #t))]
            [canvas
             (make-canvas sf
               (lambda (delay)
                 (if delay
                     (if (and (integer? delay)
                              (exact? delay)
                              (<= 0 delay (most-positive-fixnum)))
                         (thread-sleep delay)
                         (error 'show-node
                           "invalid delay ~s (expected #f or nonnegative integer)"
                           delay))
                     (begin
                       (show next)
                       (unless (eq? (thread-receive-msg q) 'destroy)
                         (hide next))))))])
       (pack (create <button> tf with (title: "Dump PostScript")
               (action:
                 (lambda (b)
                   (let ([psout
                          (swl:file-dialog "Print PostScript to:" 'save
                            (parent: top))])
                     (when psout
                       (with-output-to-file psout
                         (lambda () (display (send canvas postscript)))
                         'replace))))))
             (fill: 'x)
             (side: 'left))
       (pack (create <button> tf with
               (title: "Close")
               (action: (lambda (b) (destroy top))))
             (fill: 'x)
             (side: 'left))
       (pack tf (fill: 'x) (side: 'top))
       (pack sf (expand: #t) (fill: 'both)))))

)
)) ; end once and let-syntax

