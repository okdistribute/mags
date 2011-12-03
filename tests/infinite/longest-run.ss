(test-group "longest-run"
   (test-equal 0 (longest-run 'a '()) ) 
   (test-equal 0 (longest-run 'a '(b b b)) )
   (test-equal 3 (longest-run 'a '(a a 1 2 3 a a a 4 a)) )
   (test-equal 2 (longest-run 5 '(1 2 3 4 5 5 6 5 6 7)) )
   (test-equal 2 (longest-run 'a '(a b c a a)) )
   (test-equal 5 (longest-run 1 '(1 1 3 1 1 1 6 1 1 1 1 1)) )
   (test-equal 3 (longest-run 'a '(a b a a a c a a a)) )
   
) 

   
