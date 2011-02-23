;;These are test cases for (plug-in list-to-plug-in index list)
(test-begin "Plug-in")

(test-equal  '(b b b b a a a b b) (plug-in '(a a a) 4 '(b b b b b b )))
(test-equal  '(a b c d) (plug-in '(a) 0 '(b c d)))
(test-equal  '(a b c x y z) (plug-in '(x y z) 3 '(a b c)))
(test-equal  '(a b c) (plug-in '() 0 '(a b c)))
(test-equal  '(a b c d) (plug-in '() 2 '(a b c d)))

(test-end "Plug-in")
