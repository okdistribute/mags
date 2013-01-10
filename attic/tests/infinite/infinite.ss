(define-from-submission ()
  all-numbers?
  ascending?
  trim-until
  count-forwards
  index-of-least
  the-price-is-right
  longest-run
  mutate
  run-mouse-program
  browse
  )

(untrace)

(define-equality-test test-eqish
  (let ((tolerance 0.0001))
    (lambda (n1 n2)
      (and (number? n1) (number? n2)
           (<= (abs (- n1 n2)) tolerance)))))

(define-equality-test test-eventually
  (lambda (possible thunk)
    (guard (x [(condition? x) #f]
              [else x])
           (let loop ([left possible])
             (if (null? left)
                 #t
                 (let ([ans ((make-engine
                               thunk)
                              (lambda (t v) v)
                              (lambda (v) (raise (make-condition))))])
                   (if (member ans possible)
                       (loop (remove ans left))
                       #f)))))))



(test-group "Assignment 6"
  (test-suite
    ("all-numbers.ss"
     "ascending.ss")
     "trim-until.ss"
     "count-forwards.ss"
     "index-of-least.ss"
     "the-price-is-right.ss"
     "longest-run.ss"
     "mutate.ss"
     "run-mouse-program.ss"
     "browse.ss"))
