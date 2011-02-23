;;test cases for graft
(test-begin "graft")

(test-treequal 
 (tree 5
        (tree 2 (leaf #\G) (leaf #\H))
        (tree 3 (leaf #\E) (leaf #\F)))
 (graft (tree 2 (leaf #\G) (leaf #\H))
        (tree 3 (leaf #\E) (leaf #\F))))

(test-treequal 
 (tree 3 (leaf #\G) (leaf #\E))
 (graft (tree 1 (leaf #\G) (empty-tree))
        (tree 2 (leaf #\E) (empty-tree))))

(test-treequal 
 (tree 5
        (leaf #\B)
        (tree 2 (leaf #\C) (leaf #\D)))
 (graft (tree 3 (leaf #\B) (empty-tree))
        (tree 2 (leaf #\C) (leaf #\D))))

(test-treequal 
 (tree 5
        (tree 2 (leaf #\C) (leaf #\D))
        (leaf #\B))
 (graft (tree 2 (leaf #\C) (leaf #\D))
        (tree 3 (leaf #\B) (empty-tree))))

(test-end "graft")
