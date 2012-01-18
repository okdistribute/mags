;;Define the tree ADT, with three nodes. A root, a left-subtree, and a right-subtree.

;;The predicate void returns true if something is void and false if it is not.
(define (void? x)
   (equal? x (void)))

;;The procedure tree defines a list with three nodes to form a "tree structure." It has a root, a left subtree that branches out from the root, and a right subtree that does the same.
(define tree
   (lambda (root left right)
      (list root left right)))

;;The procedure empty-tree (thunk) returns an empty list, which is used to denote an tree with an empty root as well as empty subtrees. 
(define empty-tree
   (lambda ()
      '()))

;;The predicate 
;;(define (tree? tr)
;;   (and (not (void? (car tr))))
;;        (list? (car (cdr tr)))
;;        (list? (car (cdr (cdr tr)))))

(define (tree? tr)
   (or (null? '())
       (and (not (void? (car tr)))
           (not (void? (cdr tr)))
           (not (void?  (cdr (cdr tr)))))))

;;With a tree structure, we can build the structure for a filesystem, with the root node being "/", the left-subtree being a list of files, and the right subtree being a list of directories, which will also be trees of the same format

(define virtual-filesystem
   (make-parameter
      (tree '/ (empty-tree) (empty-tree))
      (lambda (x)
         (assert (tree? x))
         x)))
