(test-group "mutate"
	(test-equal '(a c c a t g c g g t) (mutate '(a c c a t g c g g t) (lambda (x y z) y)) )
 	(test-set '((a a g) (a c g))  (mutate '(a c g) (lambda (x y z) (if (zero? (random 2)) x y))))
  	(test-equal '(a a c c a t g c g t) (mutate '(a c c a t g c g g t) (lambda (x y z) x)) )
 	(test-equal '(a g g g g g g g g t) (mutate '(a c c a t g c g g t) (lambda (x y z) 'g)) )
	(test-equal '(a a c a t c g g t t) (mutate '(a c c a t g c g g t) (lambda (x y z)
	         (cond
                  [(equal? y 'c) x]
                  [(equal? y 'a) y]
                  [(equal? y 't) y]
                  [else z]))))
   	(test-equal '(a c a t g c g g t t) (mutate '(a c c a t g c g g t) (lambda (x y z) z)))
)


 	
