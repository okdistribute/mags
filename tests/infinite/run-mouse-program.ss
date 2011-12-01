(test-group "run-mouse-program"
	(test-equal '((termination normal)(address 1)(mouse-position 2)(cheese uneaten)) (run-mouse-program 0 3 6 '(left stop right right stop)) )
	(test-equal '((termination normal)(address 1)(mouse-position 2)(cheese uneaten)) (run-mouse-program 0 3 6 '(left stop right eat right stop)))
	(test-equal '((termination no-cheese-here)(address 2)(mouse-position 3)(cheese uneaten)) (run-mouse-program 0 3 6 '(left right eat right stop)) )
	(test-equal '((termination normal)(address 8)(mouse-position 7)(cheese uneaten)) (run-mouse-program 0 3 6 '(left right right right right left right right stop)) )
   	(test-equal '((termination normal)(address 9)(mouse-position 7)(cheese eaten)) (run-mouse-program 0 3 6 '(left right right right right left right eat right stop)) )
        (test-equal '((termination cat-got-me)(address 2)(mouse-position 0)(cheese uneaten)) (run-mouse-program 0 3 6 '(left left left right right stop)) )
   	(test-equal '((termination no-cheese-here)(address 2)(mouse-position 3)(cheese eaten)) (run-mouse-program 1 2 3 '(right eat eat stop)) )
) 

	
   
