;;Test case suite for (insert rel? item ls)
(test-group "insert"

(test-equal  
            '(1 3 5 6 7 9 11) 
            (insert < 6 '(1 3 5 7 9 11)))
(test-equal '(12 10 9 7 4 3 2 1 0) 
            (insert > 2 '(12 10 9 7 4 3 1 0)))
(test-equal 
            '("asp" "boa" "cat" "dog" "emu")
            (insert string<? "cat" '("asp" "boa" "dog" "emu")))
(test-equal 
            '(#\A #\e #\I #\o #\U #\y)
            (insert char-ci<? #\y (string->list "AeIoU")))
(test-equal 
            '(#t #t #t #f #f)
            (insert (lambda (x y) x) #f '(#t #t #t #f)))
(test-equal 
	    '("pig" "frog" "bird" "mouse" "goose" "monkey" "elephant")
            (insert (lambda (s t) (<= (string-length s) (string-length
             t))) "mouse" '("pig" "frog" "bird" "goose" "monkey"
             "elephant")))
(test-equal '(0 1 2 3 4)
            (insert < 0 '(1 2 3 4)))
)