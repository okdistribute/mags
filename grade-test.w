#!chezscheme
(load "load.w")
(load "safe-scheme.ss")
(cd "tests/a10")
(current-test-file "a10.ss")
(current-sandbox-name '(safe-scheme))

(grade ("menzel.ss"
	"menzel.grade" 
	"menzel.mail"))
(grade ("load-error.ss"
	"load-error.grade" 
	"load-error.mail"))
(grade ("submission.ss" 
	"submission.grade" 
	"submission.mail"))

(cd "../..")


