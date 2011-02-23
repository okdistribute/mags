;;Test cases for inorder
(test-group "inorder"
  (test-equal  '() (inorder (empty-tree)))
  (test-equal  '(a) (inorder (leaf 'a)))
  (test-equal  '(() #t (b) 8 (empty-tree) 5)
              (inorder (tree 8
                   (tree #t (leaf '()) (leaf '(b)))
                   (tree 5 (leaf '(empty-tree)) (empty-tree)))))
  (test-equal  
              '("ant" "cat" "dog" "gnu" "rat")
              (inorder animal-tree))

)

