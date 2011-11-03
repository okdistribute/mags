#!chezscheme

(load "load.w")
(cd "tests")
(current-test-file "assignment.ss")

(parameterize ([current-test-runner (test-runner-quiet (current-output-port) "submission.mail")])
              (grade "submission.ss"))

(cd "..")