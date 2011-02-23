;; In this problem, we define an implementation of the binary tree
;; ADT. The empty tree is represented by the empty string.
;; Nonempty trees are represented as a vector of length three.

;; Constructors
(define empty-tree
  (lambda ()
    ""))

(define tree
  (lambda (root left right)
    (cond
     ((not (tree? left))
      (error 'tree "~s must be a tree." left))
     ((not (tree? right))
      (error 'tree "~s must be a tree." right))
     (else (vector root left right)))))

;; Type Predicates
(define empty-tree?
  (lambda (tr)
    (and (string? tr) (zero? (string-length tr)))))

(define tree?
  (lambda (tr)
    (or (empty-tree? tr)
        (and (vector? tr)
             (= (vector-length tr) 3)
             (tree? (vector-ref tr 1))
             (tree? (vector-ref tr 2))))))

;; Selectors

(define root-value
  (lambda (tr)
    (cond
     ((or (not (tree? tr)) (empty-tree? tr))
      (error 'root-value "~s must be a nonempty tree" tr))
     (else
      (vector-ref tr 0)))))

(define left-subtree
  (lambda (tr)
    (cond
     ((or (not (tree? tr)) (empty-tree? tr))
      (error 'left-subtree "~s must be a nonempty tree" tr))
     (else
      (vector-ref tr 1)))))

(define right-subtree
  (lambda (tr)
    (cond
     ((or (not (tree? tr)) (empty-tree? tr))
      (error 'right-subtree "~s must be a nonempty tree" tr))
     (else
      (vector-ref tr 2)))))

;; Mutators

(define set-root-value!
  (lambda (tr root)
    (cond
     ((or (not (tree? tr)) (empty-tree? tr))
      (error 'set-root-value! "~s must be a nonempty tree" tr))
     (else
      (vector-set! tr 0 root) ))))

(define set-left-subtree!
  (lambda (tr left)
    (cond
     ((or (not (tree? tr)) (empty-tree? tr))
      (error 'set-left-subtree! "~s must be a nonempty tree" tr))
     ((not (tree? left))
      (error 'set-left-subtree! "~s must be a tree" left))
     (else
      (vector-set! tr 1 left) ))))

(define set-right-subtree!
  (lambda (tr right)
    (cond
     ((or (not (tree? tr)) (empty-tree? tr))
      (error 'set-right-subtree! "~s must be a nonempty tree" tr))
     ((not (tree? right))
      (error 'set-right-subtree! "~s must be a tree" right))      
     (else
      (vector-set! tr 2 right) ))))

;;

(define leaf
  (lambda (item)
    (tree item (empty-tree) (empty-tree))))

(define leaf?
  (lambda (tr)
    (and (empty-tree? (left-subtree tr))
	 (empty-tree? (right-subtree tr)))))