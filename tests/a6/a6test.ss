#|
a6
stefan lee 
test file
|#

(define all-numbers?
  (lambda (ls)
    (or (null? ls )(and (number? (car ls)) (all-numbers? (cdr ls))))))

(define ascending?
  (lambda (ls)
    (or (null? ls) (null? (cdr ls)) (and (< (car ls) (cadr ls)) (ascending? (cdr ls))))))


(define trim-until
  (lambda (a ls)
    (cond
      [(null? ls) '()]
      [(a (car ls)) ls]
      [else (trim-until a (cdr ls))])))

(define count-forwards-helper
  (lambda (x ls)
    (if (= x -1)
        ls
        (count-forwards-helper (sub1 x) (cons x ls)))))

(define count-forwards
  (lambda (x)
    (count-forwards-helper x '())))



(define index-of-least-helper
  (lambda (min index pos ls)
    (cond
      [(null? ls) index]
      [(< (car ls) min) (index-of-least-helper (car ls) pos (add1 pos) (cdr ls))]
      [else (index-of-least-helper min index (add1 pos) (cdr ls))])))

(define index-of-least
  (lambda (ls)
    (index-of-least-helper (car ls) 0 1 (cdr ls))))


(define the-price-is-right-helper
  (lambda (val best guesses)
    (cond
      [(null? guesses) (if (> best val) #f best)]
      [(or (and (< best (car guesses))(< (car guesses) val)) (> best val))     
       (the-price-is-right-helper val (car guesses) (cdr guesses))]
      [else (the-price-is-right-helper val best (cdr guesses))])))

(define the-price-is-right
  (lambda (val guesses)
    (if (null? guesses)
        #f
        (the-price-is-right-helper val (car guesses) (cdr guesses)))))




(define longest-run-helper
  (lambda (a n l ls)
    (cond
      [(null? ls) (max l n)]
      [(equal? a (car ls)) (longest-run-helper a (add1 n) l (cdr ls))]
      [else (longest-run-helper a 0 (max l n) (cdr ls))])))


(define longest-run 
  (lambda (a ls)
    (longest-run-helper a 0 0 ls)))




(define mutate-helper
      (lambda (rule ls last)
        (if (null? (cdr ls))
            ls
            (cons (rule last (car ls) (cadr ls)) 
                  (mutate-helper rule (cdr ls) (car ls))))))
    
(define mutate
  (lambda (ls rule)
    (cons (car ls) (mutate-helper rule (cdr ls) (car ls)))))



    
(define run-mouse-helper
  (lambda (cat mouse cheese cheese-eaten address program)
    (cond
      [(equal? (car program) 'stop)(list (list 'termination 'normal) 
                                         (list 'address (sub1 address)) 
                                         (list 'mouse-position mouse) 
                                         (list 'cheese cheese-eaten))]
      [(= cat mouse) (list (list 'termination 'cat-got-me) 
                           (list 'address (- address 2)) 
                           (list 'mouse-position mouse) 
                           (list 'cheese cheese-eaten))]
      [(equal? (car program) 'eat) (if (or (equal? cheese-eaten 'eaten) 
                                   (not (= mouse cheese)))
                                       (list (list 'termination 'no-cheese-here) 
                                       (list 'address (sub1 address)) 
                                       (list 'mouse-position mouse) 
                                       (list 'cheese cheese-eaten))
                                       (run-mouse-helper cat mouse cheese 'eaten
                                       (add1 address) (cdr program)))]
      [(equal? (car program) 'left) (run-mouse-helper cat (sub1 mouse) cheese 
                                    cheese-eaten (add1 address) (cdr program))]
      [(equal? (car program) 'right)(run-mouse-helper cat (add1 mouse) cheese 
                                    cheese-eaten (add1 address) (cdr program))]
      )))
 
(define run-mouse-program
  (lambda (cat mouse cheese program)
    (run-mouse-helper cat mouse cheese 'uneaten 1 program)))



(define browse-helper
  (lambda (current history future actions)
    (cond
      [(null? actions) current]
      [(equal? (car actions) 'back) (if (null? history)
                                        (browse-helper current history future
                                          (cdr actions))
                                        (browse-helper (car history) 
                                          (cdr history) (cons current future)
                                          (cdr actions)))]
      [(equal? (car actions) 'forward) (if (null? future)
                                         (browse-helper current history future 
                                           (cdr actions))
                                         (browse-helper (car future) 
                                          (cons current history) (cdr future)
                                          (cdr actions)))]
      [else (browse-helper (car actions) (cons current history) future 
               (cdr actions))])))

(define browse
  (lambda (start actions)
   (browse-helper start '() '() actions)))
