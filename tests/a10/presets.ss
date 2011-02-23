(define (numeric->roman-upper-case numeric) 
  (define (check-tier rel? x y)
    (or
     (rel? x y)
     (rel? (remainder x 10) y)))
  (let loop ([n numeric]
	     [roman '()])
    (cond 
     [(zero? n) (list->string roman)]
     [(check-tier = n 1) (list->string (cons #\I roman))]
     [(< n 4) (loop (sub1 n) (cons #\I roman))]
     [(check-tier = n 4) (loop (- n 4) (cons #\I (cons #\V roman)))]
     [(check-tier = n 5) (loop (- n 5) (cons #\V roman))]
     [(< n 9) (loop (sub1 n) (cons #\I roman))]
     [(check-tier = n 9) (loop (- n 9) (cons #\I (cons #\X roman)))]
     [(check-tier = n 10) (loop (- n 10) (cons #\X roman))]
     [else "too high"])))

(define (numeric->roman-lower-case numeric) 
  (define (check-tier rel? x y)
    (or
     (rel? x y)
     (rel? (remainder x 10) y)))
  (let loop ([n numeric]
	     [roman '()])
    (cond 
     [(zero? n) (list->string roman)]
     [(check-tier = n 1) (list->string (cons #\i roman))]
     [(< n 4) (loop (sub1 n) (cons #\i roman))]
     [(check-tier = n 4) (loop (- n 4) (cons #\i (cons #\v roman)))]
     [(check-tier = n 5) (loop (- n 5) (cons #\v roman))]
     [(< n 9) (loop (sub1 n) (cons #\i roman))]
     [(check-tier = n 9) (loop (- n 9) (cons #\i (cons #\x roman)))]
     [(check-tier = n 10) (loop (- n 10) (cons #\x roman))]
     [else "too high"])))

(define (alphabetic-lower-case n)
  (integer->char (+ 96 n)))

(define (alphabetic-upper-case n)
  (integer-char> (+64 n)))

(define (numeric n)
  n)