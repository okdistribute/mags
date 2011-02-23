;;test cases for list->bst
(test-begin "list-bst")

  (test-treequal (empty-tree)
                 (list->bst > '()))
  (test-treequal
   (tree 7
         (tree 3
               (tree 2 (leaf 1) (empty-tree))
               (leaf 4))
         (tree 9 (tree 7 (empty-tree) (leaf 8)) (empty-tree)))
   (list->bst < '(7 3 9 4 2 7 8 1)))

  (test-treequal   (tree 2 (leaf 3) (leaf 1)) (list->bst > '(2 1 3)))

  (test-treequal  (tree 3 (empty-tree) (tree 1 (leaf 2) (empty-tree)))
                (list->bst > '(3 1 2)))

  (test-treequal  (tree 3 (empty-tree) (tree 1 (leaf 2) (empty-tree)))
                 (list->bst (lambda (x y) (> x y)) '(3 1 2)))

  (test-treequal
    (tree 1
           (tree 2
                 (tree 3
                       (tree 4 (leaf 5) (empty-tree))
                       (empty-tree))
                 (empty-tree))
           (empty-tree))
    (list->bst > '(1 2 3 4 5)))

(test-end "list-bst")
