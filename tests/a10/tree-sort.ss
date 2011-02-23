;;test cases for tree-sort
(test-begin "tree-sort")

(test-equal
            '(9 8 6 5 4 3 3 2 0)
            (tree-sort > '(8 3 2 9 4 5 6 0 3)))

(test-equal
            '("bears" "lions" "tigers") 
            (tree-sort string<? '("lions" "tigers" "bears")))
(test-equal
            '(1 2 3 4 7 7 8 9) 
            (tree-sort < '(7 3 9 4 2 7 8 1)))


(test-equal
            '("pumpkin" "prune" "pomegranate" "plum" "pear" "peach")
            (tree-sort string>?
              '("pumpkin" "prune" "pomegranate" "plum" "pear" "peach")))
        
(test-equal
            '(1 2 3 4 7 7 8 9) 
            (tree-sort (lambda (x y) (< x y)) '(7 3 9 4 2 7 8 1)))

(test-end "tree-sort")