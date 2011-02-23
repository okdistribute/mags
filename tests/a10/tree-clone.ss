;;test cases for tree-clone
;;tests define-equality-test used outside of the testing group
(let ()
(define-equality-test test-same-shape same-shape?)
(test-begin "tree-clone")

  (test-treequal "tree-clone on empty-tree"
                 (empty-tree)
                 (tree-clone (empty-tree) 7))
  (test-same-shape "tree-clone same shape as animal tree"
                   animal-tree
                   (tree-clone (tree 1
                                   (tree 1 (leaf 1) (empty-tree))
                                   (tree 1 (leaf 1) (empty-tree))) 2))
  (test-treequal "tree-clone basic test"
   (tree 0
         (tree 0 (leaf 0) (leaf 0))
         (tree 0 (leaf 0) (leaf 0)))
   (tree-clone (tree 1
                     (tree 1 (leaf 1) (leaf 1))
                     (tree 1 (leaf 1) (leaf 1))) 1))
  (test-treequal "tree-clone on leaf"
                 (leaf 0)
                 (tree-clone (leaf 1) 1))
  (test-treequal "tree-clone on leaf"
                 (leaf 1)
                 (tree-clone (leaf 0) 1))
  (test-treequal "tree-clone with large number on leaf"
                 (leaf 1)
                 (tree-clone (leaf 1) 9999999999999))

(test-end "tree-clone")
)
