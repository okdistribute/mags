(test-group "pick-one-at-random"
    (test-set '(42 83) (pick-one-at-random 42 83))
    (test-set '(42 #f) (pick-one-at-random 42 #f))
    (test-set '(#t 64) (pick-one-at-random #t 64))
    (test-set '(1 -1) (pick-one-at-random 1 -1))
    (test-set '(4 3) (pick-one-at-random 3 4))
    (test-set '(blah 83) (pick-one-at-random 'blah 83)))
