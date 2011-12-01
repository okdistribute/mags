(test-group "count-forwards"
	(test-equal '(0 1 2 3 4 5) (count-forwards 5) )
	(test-equal '(0) (count-forwards 0) )
	(test-equal '(0 1 2 3) (count-forwards 3) )
	(test-equal '(0 1 2 3 4) (count-forwards 4) )
	(test-equal '(0 1 2) (count-forwards 2) )
) 