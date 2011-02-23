(define (numeric->roman numeric) 
  (define (check-tier rel? x y)
    (or
     (rel? x y)
     (rel? (remainder x 10) y)))
  (let loop ([n numeric]
	     [roman '()])
    (cond 
     [(zero? n) (list->string roman)]
     [(check-tier = n 1) (list->string (cons #\I roman))]
     [(check-tier < n 4) (loop (sub1 n) (cons #\I roman))]
     [(check-tier = n 4) (loop (- n 4) (cons #\I (cons #\V roman)))]
     [(check-tier = n 5) (loop (- n 5) (cons #\V roman))]
     [(check-tier < n 9) (loop (sub1 n) (cons #\I roman))]
     [(check-tier = n 9) (loop (- n 9) (cons #\I (cons #\X roman)))]
     [(check-tier = n 10) (loop (- n 10) (cons #\X roman))]
     [else "too high"])))