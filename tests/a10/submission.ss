(load "tree.ss")

;; 1
(define plug-in
  (lambda (ls1 i ls2)
    (if (zero? i)
	(append ls1 ls2)
	(cons (car ls2)
	      (plug-in ls1 (sub1 i) (cdr ls2))))))

;; 2a
;;inserts incorrectly
(define insert
  (lambda (rel? x ls)
    (define help
      (lambda (ls)
        (if (null? ls)
            (list x)
            (if (rel? x (car ls))
                (cons (car ls) (help (cdr ls)))
                (cons x ls)))))
    (help ls)))

;; 2b
(define unordered?
  (lambda (rel? ls)
    (define help
      (lambda (ls)
	(cond
	 [(or (null? ls) (null? (cdr ls))) #f]
	 [(rel? (car ls) (cadr ls)) (help (cdr ls))]
	 [else ls])))
    (help ls)))

;; 3
(define make-weight-list
  (lambda (s)
    (define extend-wlist
      (lambda (c wlist)
	(if (null? wlist)
	    (list (list c 1))
	    (if (char=? c (caar wlist))
		(cons (list c (add1 (cadar wlist)))
		      (cdr wlist))
		(cons (car wlist)
		      (extend-wlist c (cdr wlist)))))))
    (define loop
      (lambda (clist wlist)
	(if (null? clist)
	    wlist
	    (loop (cdr clist) (extend-wlist (car clist) wlist)))))
    (loop (string->list s) '())))

;; 4
;; infinite loop
(define free-vars
  (lambda (expr env)
    (let loop ([i 0])
      (loop (add1 i)))))

;; 5
(define tree-top
  (lambda (tr h)
    (if (or (= h 1) (empty-tree? tr))
	(empty-tree)
	(tree (root-value tr)
	      (tree-top (left-subtree tr) (- h 1))
	      (tree-top (right-subtree tr) (- h 1))))))

;; 6a
(define tree-map
  (lambda (proc tr)
     (if (empty-tree? tr)
	 (empty-tree)
	 (tree (proc (root-value tr))
	       (tree-map proc (left-subtree tr))
	       (tree-map proc (right-subtree tr))))))

;; 6b
(define tree-clone
  (lambda (tr freq)
    (tree-map (lambda (b)
		(if (zero? (random freq))
		    (if (zero? b) 1 0)
		    b))
	      tr)))

;; 6c
(define switcheroo
  (lambda (tr env)
    (tree-map (lambda (x)
		(if (symbol? x)
		    (let ([y (assoc x env)])
		      (if y
			  (cadr y)
			  0))
		    x))
	      tr)))

;; 7a 
(define inorder
  (lambda (tr)
    (define help
      (lambda (tr acc)
	(if (empty-tree? tr)
	    acc
	    (help (left-subtree tr)
		  (cons (root-value tr)
			(help (right-subtree tr)
			      acc))))))
    (help tr '())))

;; 7b
(define bst-insert
  (lambda (rel? x bst)
    (define help
      (lambda (bst)
	(if (empty-tree? bst)
	    (leaf x)
	    (if (rel? x (root-value bst))
		(tree (root-value bst)
		      (help (left-subtree bst))
		      (right-subtree bst))
		(tree (root-value bst)
		      (left-subtree bst)
		      (help (right-subtree bst)))))))
    (help bst)))

;; 7c
(define list->bst
  (lambda (rel? ls)
    (define help
      (lambda (ls bst)
	(if (null? ls)
	    (car ls)
	    (help (cdr ls) (bst-insert rel? (car ls) bst)))))  
    (help ls (empty-tree))))

;; 7d
(define tree-sort
  (lambda (rel? ls)
    (inorder (list->bst < ls))))

;; 8a ;;infinite loop

;(define sort-by-weight
;(lambda (wlist)
;(let loop ([i 0])
;  (loop (add1 i)))))

;; 8b
(define make-start-trees
  (lambda (wlist)
    (map (lambda (wc)
	   (tree (cadr wc) (leaf (car wc)) (empty-tree)))
	 (sort-by-weight wlist))))

;; 8c
(define graft
  (lambda (tr1 tr2)
    (let ([weight (+ (root-value tr1)
		     (root-value tr2))])
      (cond
       [(and (empty-tree? (right-subtree tr1))
	     (empty-tree? (right-subtree tr2))) (tree weight
						      (left-subtree tr1)
						      (left-subtree tr2))]
       [(empty-tree? (right-subtree tr1)) (tree weight
						(left-subtree tr1)
						tr2)]
       [(empty-tree? (right-subtree tr2)) (tree weight
						tr1
						(left-subtree tr2))]
       [else (tree weight tr1 tr2)]))))

;; 8d
(define make-huffman-tree
  (lambda (wlist)
    (define help
      (lambda (tlist)
	(if (null? (cdr tlist))
	    (car tlist)
	    (help (insert (lambda (tr1 tr2)
			    (< (root-value tr1) (root-value tr2)))
			  (graft (car tlist) (cadr tlist))
			  (cddr tlist))))))
    (help (make-start-trees wlist))))

;; 8e

;; encode from a9
(define encode-char
  (lambda (c htr)
    (cond 
     [(empty-tree? htr) #f]
     [(leaf? htr) (if (equal? (root-value htr) c)
		      '()
		      #f)]
     [else (let ([left-path (encode-char c (left-subtree htr))])
	     (if left-path
		 (cons 0 left-path)
		 (let ([right-path (encode-char c (right-subtree htr))])
		   (if right-path
		       (cons 1 right-path)
		       #f))))])))

(define encode
  (lambda (s htr)
    (encode-help (string->list s) htr)))

(define encode-help
  (lambda (ls htr)
    (apply append
	   (map (lambda (c)
		  (encode-char c htr)) ls))))

(define saved-bits 44125)
;   (- (* 8 (string-length moby-dick))
;      (length (encode moby-dick
; 		     (make-huffman-tree (make-weight-list moby-dick))))))
  
