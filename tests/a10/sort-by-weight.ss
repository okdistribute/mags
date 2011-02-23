;;test cases for sort-by-weight
(test-begin "sort-by-weight")

(test-equal 
 '((#\C 1) (#\D 2) (#\E 3) (#\F 4)
   (#\G 5) (#\H 6) (#\B 7) (#\A 8))
 (sort-by-weight '((#\A 8) (#\B 7) (#\C 1) (#\D 2)
                   (#\E 3) (#\F 4) (#\G 5) (#\H 6))))

(test-equal
 '((#\C 1) (#\I 1) (#\s 1) (#\h 1) (#\. 1)
  (#\a 2) (#\space 2) (#\m 2) (#\e 2) (#\l 3))
 (sort-by-weight '((#\C 1) (#\a 2) (#\l 3) (#\space 2) 
                   (#\m 2) (#\e 2) (#\I 1) (#\s 1) (#\h 1) (#\. 1))))
(test-end "sort-by-weight")
