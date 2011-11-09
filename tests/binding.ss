;;/append/ is redefined in the submission as /cons/. this should use
;;the submission's definition of /append/ (which is now /cons/) and
;;not the built-in scheme /append/.
(test-group "binding test"
  (test-equal '((1 2 3) 4 5 6) (binding '(1 2 3) '(4 5 6))))