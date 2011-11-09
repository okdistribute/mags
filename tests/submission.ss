(define plus
  (lambda (x y)
    (+ x y)))

(module (binding)
        
        (define binding
          (lambda (ls1 ls)
            (append ls1 ls)))

        (define append cons))