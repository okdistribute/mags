

;problem 1,define a produre all-numbers? takes a list ls and returns #t
(trace-define all-numbers?
  (lambda (ls)
    
    (or (null? ls) (and (number? (car ls)) (all-numbers?(cdr ls))))))

;problem 2, trace-define ascending? takes a list of numbers nums 
;and returns #f if the numbers appear in ascending
(trace-define ascending?
  (lambda (ls)
    (or (null? ls) (or (null?(cdr ls)) 
                       
                       (and (< (car ls) (car (cdr ls))) (ascending? (cdr ls)))))))

;problem2 ,trace-define procedure trim-until? 

(trace-define trim-until 
  (lambda (proc ls)
    (if (null? ls)
        '()
        (if (proc (car ls))
            ls
            (trim-until proc (cdr ls))))))
;problem 3.trace-define count-forwards
(trace-define count-forwards
  (lambda (n) 
    (tail-recursive n 0)))



(trace-define tail-recursive
  (lambda (x y)
    ( if (equal? x -1)
     '()
     (cons y (tail-recursive (- x 1) (add1 y))))))


;problem 4 ,trace-define index-of-least
(trace-define index-of-least
  (lambda (ls)
    (index-of-least-helper ls (car ls) 0 0)))

(trace-define index-of-least-helper
  (lambda (ls x y z)
    (if (null? ls) 
        y
        (if (<= x (car ls))
            (index-of-least-helper (cdr ls) x y (add1 z))
            (index-of-least-helper (cdr ls) (car  ls) z (add1 z) ))))) 

;problem 5 trace-define the-price-is-right

(trace-define the-price-is-right
  (lambda (n ls)
    ( if (null? ls)
     #f
     (the-price-is-right-helper ls n 0))))


(trace-define the-price-is-right-helper
  (lambda (ls x y)
    (if (null? ls) 
        (if (equal? y 0)
            #f
            y)
        
        (if (> (car ls) x)
            (the-price-is-right-helper (cdr ls) x y)
            (if (>= (car ls) y)
                (the-price-is-right-helper (cdr ls) x (car ls)) 
                
                (the-price-is-right-helper (cdr ls) x y))))))

        
;problem 6,trace-define longest-run,
(trace-define longest-run
  (lambda(x ls)
    (longest-run-helper ls x 0 0)))


(trace-define longest-run-helper
  (lambda (ls x y z)
    (if (> y z)
        (longest-run-helper ls x y y)
        (if (null? ls) 
            z
            (if (equal? (car ls) x)
                (longest-run-helper (cdr ls) x (add1 y) z)
                (longest-run-helper (cdr ls) x 0 z))))))

        
;trace-define mutate

(trace-define mutate
  (lambda (ls proc)
    
    (mutate-helper ls proc (car ls) (car (cdr ls)) (car(cddr ls)))))

    
(trace-define mutate-helper
  (lambda( ls proc x y z)
    (if (null? (cdddr ls))
        '()
        (if (null? (cddr ls))
            '()
            (cons x  (cons (proc x y z) (mutate-helper ls proc (car (cdr ls)) (car(cdr(cdr ls))) (car(cdr(cdr(cdr ls)))))))))))

            

;trace-define   run-mouse-program.

(trace-define run-mouse-program
  (lambda (x y z ls)
    (helper x y z ls 0 0 0)))



(trace-define helper
  (lambda(x y z ls n a b)
    (if (equal? (car ls) 'stop)
        (if (and (= a 0) (= b 0))
            (list (list 'termiandation 'normal)
             (list 'address n)
             (list 'mouse-position y)
             (list 'cheese 'uneaten))
            
            (if (and (= a 0) (= b 1))
                (list (list 'termiandation 'normal)
                 (list 'address n)
                 (list 'mouse-position y)
                 (list 'cheese 'eaten))
                (if (and (= a 1) (= b 0))
                    (list (list 'termiandation 'no-cheese-here)
                     (list 'address n)
                     (list 'mouse-position y)
                     (list 'cheese 'uneaten))
                    (if (and (= a 1) (= b 1))
                        (list (list 'termiandation 'no-cheese-here)
                         (list 'address n)
                         (list 'mouse-position y)
                         (list 'cheese 'eaten))
                        (if (and (= a 2) (= b 0))
                            (list (list 'ermiandation 'cat-got-me)
                             (list 'address n)
                             (list 'mouse-position y)
                             (list 'cheese 'uneaten))
                            
                            ( list (list 'ermiandation 'cat-got-me)
                             (list 'address n)
                             (list 'mouse-position y)
                             (list 'cheese 'eaten)))))))
        
        (if (and (equal? (car ls) 'left) (equal? x y))
            
            ( helper x (- y 1) z (cdr ls) (add1 n) 2 b)
            
            (if (equal? (car ls) 'left)
                ( helper x (- y 1) z (cdr ls) (add1 n) a b)
                
                (if (equal? (car ls) 'right)
                    
                    (helper x (+ y 1) z (cdr ls) (add1 n) a b)
                    
                    
                    (if (and (equal? (car ls) 'eat) (equal? y z))
                        ( if (= a 2)
                         (helper x y z (cdr ls) n a 1)
                         
                         (helper x y z (cdr ls) n 1 1))
                        (helper x y z (cdr ls) n a b)))))))) 

           

          



    

