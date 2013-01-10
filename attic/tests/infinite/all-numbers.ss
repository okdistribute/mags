(test-group "all-numbers?"
	(test-equal #t (all-numbers? '()) )
	(test-equal #t (all-numbers? '(2 -4 6.3 8)) )
   	(test-equal #t (all-numbers? '(2 3 0 2/3 4 5 6 7 8 9)) )
   	(test-equal #t (all-numbers? '(2 3 0 3 4 5 6 7 8 9)) )
   	(test-equal #f (all-numbers? '(3 0 two four six eight)) )
   	(test-equal #f (all-numbers? '(2 4 5 6 8 10 (+ 2 3))) )
   	(test-equal #f (all-numbers? '(cat 0 eight)) )
   	(test-equal #t (all-numbers? '(2)) )
   	(test-equal #f (all-numbers? '((2))) ))
   
   