;;Test cases for bst-insert
(test-begin "bst-insert")

  (test-treequal  "bst-insert leaf into animal-tree"
        (tree "dog"
               (tree "cat" (leaf "ant") (empty-tree))
               (tree "rat"
                     (tree "gnu" (empty-tree) (leaf "pig"))
                     (empty-tree)))
        (bst-insert string<? "pig" animal-tree))

  (test-treequal "bst-insert a root into animal-tree"
        (bst-insert string<? "cat" animal-tree)
        (tree "dog"
               (tree "cat" (leaf "ant") (leaf "cat"))
               (tree "rat" (leaf "gnu") (empty-tree))))

(test-end "bst-insert")
