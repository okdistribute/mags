;;Test case suite for (tree-map procedure tree)
(test-begin "tree-map")

(test-equal 
 (tree 100 
        (tree 99 (leaf 97) (empty-tree))
        (tree 114 (leaf 103) (empty-tree)))
 (tree-map
  (lambda (pet) (char->integer (car (string->list pet))))
  animal-tree))

(test-equal 
 (tree 2 (leaf 3)
        (tree 4 (leaf 5)
              (tree 6 (leaf 7) (leaf 8))))
 (tree-map add1 (tree 1
                      (leaf 2)
                      (tree 3 (leaf 4)
                            (tree 5 (leaf 6) (leaf 7))))))

(test-equal 
 (tree 2
        (tree 3 (leaf 4)
              (tree 5 (leaf 6) (leaf 7)))
        (leaf 8))
 (tree-map add1 (tree 1
                      (tree 2 (leaf 3)
                            (tree 4 (leaf 5) (leaf 6)))
                      (leaf 7))))

(test-end "tree-map")
