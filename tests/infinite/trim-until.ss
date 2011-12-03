(test-group "trim-until"
	(test-equal '(0 3 9 8 0 0 6) (trim-until zero? '(3 5 9 2 0 3 9 8 0 0 6)) )
	(test-equal '(+ 3 7 - 5 *) (trim-until symbol? '(1 2 + 3 7 - 5 *)) )
	(test-equal '(12 8 2 19) (trim-until (lambda (x) (> x 10)) '(7 -3 6 10 5 12 8 2 19)) )	
        (test-equal '() (trim-until null? '(a '() c d)) )
   	(test-equal '(3 d 5 6 7) (trim-until (lambda (x) (equal? x 3)) '(a 2 3 d 5 6 7)) )
   	(test-equal '(2) (trim-until even? '(1 1 3 2)) ) )
   
