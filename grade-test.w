#!chezscheme
(load "load.w")
;(load "iu-c211/c211/safe-scheme.ss")
(load "safe-scheme.ss")
(cd "tests/a10")
(current-test-file "a10.ss")
(current-sandbox-name '(safe-scheme))

(parameterize ([current-test-runner (test-runner-quiet (current-output-port) "menzel.mail")])
              (grade "menzel.ss"))

(parameterize ([current-test-runner (test-runner-quiet (current-output-port) "submission.mail")])
              (grade "submission.ss"))


(cd "../..")


