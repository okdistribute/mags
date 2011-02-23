;;Test cases for free-vars
(test-begin "free-vars")

  (test-equal "free-vars #t '((x 3))" '() (free-vars #t '((x 3))))
  (test-equal "free-vars gives empty list" '() (free-vars 1 '((x 3))))
  (test-equal "free-vars" '(y) (free-vars 'y '((x 3))))
  (test-equal "free-vars" '(+ + y) (free-vars '(+ x ( + y 4)) '((x 3))))
  (test-equal "free-vars makes list" '(a b c d e f g h i) (free-vars
                                    '((a b c) (d e f) (g h i)) '()))
  (test-equal "free-vars combines nested lists" '(a x y z c d e p q r m n o h i)
        (free-vars '((a (x y z) c) (d e (p q r)) ((m n o) h i)) '()))
  (test-equal "free-vars combines and statement" '(and = x z < x + y z)
              (free-vars '(and (= x z) (< x (+ y z))) '()))
  (test-equal "free-vars complex input" '(y)
              (free-vars '(+ x (- (* 2 x) y))
                (list '(x 3) '(x 2) (list '+ +) (list '- -) (list '* *))))

(test-end "free-vars")
              
              
