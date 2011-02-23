#!chezscheme
(load "load.w")
(cd "tests/a10")
(current-test-file "a10.ss")
;(load "../../c211/c211/safe-scheme.ss")
(current-sandbox-name '(chezscheme))
#|
(define sub "menzel")
(parameterize ([test-runner-current (test-runner-quiet (string-append "reports/" sub ".grade")
						       (string-append "reports/" sub ".mail"))])
	      (grade "menzel.ss")
	      (set! sub "submission")
	      (grade "submission.ss"))
|#
(grade ("menzel.ss"
	"menzel.grade" 
	"menzel.mail"))
(grade ("submission.ss" 
	"submission.grade" 
	"submission.mail"))

(cd "../..")


