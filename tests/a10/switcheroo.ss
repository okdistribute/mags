;;Test cases for switcheroo
(test-group "switcheroo"
	    
  (test-treequal "switcheroo on empty tree"
	 (empty-tree)
	 (switcheroo (empty-tree) '((a 3) (b 5) (c 4))))
  (test-treequal "switcheroo of leaf"
	 (leaf 3)
	 (switcheroo (leaf 'a) '((a 3) (b 5) (c 4))))
  (test-treequal "switcheroo on tree 1"
		 (tree + (leaf 3) (leaf 0))
		 (switcheroo (tree '+ (leaf 3) (leaf 'a))
			     (list (list '+ +))))
  (test-treequal "switcheroo on tree 3" 
		 (tree #f (leaf 3) (leaf -))
                 (switcheroo (tree #f (leaf 3) (leaf -)) '((#f 4))))
)
