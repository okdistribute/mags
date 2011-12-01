(test-group "index-of-least"
	(test-equal 0 (index-of-least '(1 2 3 4 5)) )
	(test-equal 1 (index-of-least '(1 0 3 4 5)) )
	(test-equal 0 (index-of-least '(1)) )
	(test-equal 1 (index-of-least '(4 -5)) )
	(test-equal 3 (index-of-least '(2 2 3 1 5)) )
	(test-equal 2 (index-of-least '(1 2 -1 4 5)) )

) 