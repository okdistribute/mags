;;This is an example test file for Assignment 10

(include "tree.ss")
;(include "c211-lib.ss")
(define same-shape?
  (lambda (tree1 tree2)
    (cond
      [(and (empty-tree? tree1) (empty-tree? tree2)) #t]
      [(or (and (empty-tree? tree1) (not (empty-tree? tree2)))
           (and (not (empty-tree? tree1)) (empty-tree? tree2))) #f]
      [else (and (same-shape? (left-subtree tree1) (left-subtree tree2))
                 (same-shape? (right-subtree tree1) (right-subtree tree2)))])))


(define treequal?
  (letrec ((check (lambda (t1 t2)
                    (cond
                     ((and (empty-tree? t1) (empty-tree? t2)) #t)
                     ((or (empty-tree? t1) (empty-tree? t2))  #f)
                     (else 
                      (and (equal? (root-value t1) (root-value t2))
                           (check (left-subtree t1) (left-subtree t2))
                           (check (right-subtree t1) (right-subtree t2)))))))) 
    (lambda (v1 v2)
      (if (and (tree? v1) (tree? v2))
          (check v1 v2)
        #f))))

(define animal-tree
  (tree "dog"
        (tree "cat"
              (leaf "ant")
              (empty-tree))
        (tree "rat"
              (leaf "gnu")
              (empty-tree))))

(formatters `((0 . ,numeric)
	      (1 . ,alphabetic-lower-case)
	      (2 . ,numeric->roman-lower-case)
	      (3 . ,alphabetic-upper-case)
	      (4 . ,numeric->roman-upper-case)))

(define-equality-test test-treequal treequal?)

(define-from-submission
  plug-in
  inorder
  insert
  bst-insert
  free-vars
  tree-clone
  switcheroo
  list->bst
  tree-sort
  sort-by-weight
  graft
  tree-map
  pick-one-at-random)

(test-group "Assignment 10"
  (test-suite
   "pick-one-at-random.ss"
   "plug-in.ss"
   "insert.ss"
   "free-vars.ss"
   ("tree-map.ss"
    "tree-clone.ss"
    ("switcheroo.ss") )
   ("inorder.ss" 
    "bst-insert.ss"
    "list-bst.ss"
    "tree-sort.ss")
   ("sort-by-weight.ss"
    "graft.ss")))
#|
(test-group "Assignment 10"
 (test-group
   (include "plug-in.ss"))

  (test-group
   (include "insert.ss"))

  (test-group
   (include "free-vars.ss"))
   
  (test-group
    (include "tree-map.ss")
    (include "tree-clone.ss")
    (include "switcheroo.ss"))

  (test-group
    (include "inorder.ss")
    (include "bst-insert.ss")
    (include "list-bst.ss")
    (include "tree-sort.ss"))

  (test-group
    (include "sort-by-weight.ss")
    (include "graft.ss")))
|#