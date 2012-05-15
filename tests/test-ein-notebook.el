(eval-when-compile (require 'cl))
(require 'ert)

(require 'ein-notebook)

(ert-deftest ein:notebook-test-notebook-name-simple ()
  (should-not (ein:notebook-test-notebook-name nil))
  (should-not (ein:notebook-test-notebook-name ""))
  (should-not (ein:notebook-test-notebook-name "/"))
  (should-not (ein:notebook-test-notebook-name "\\"))
  (should-not (ein:notebook-test-notebook-name "a/b"))
  (should-not (ein:notebook-test-notebook-name "a\\b"))
  (should (ein:notebook-test-notebook-name "This is a OK notebook name")))

(ert-deftest ein:notebook-console-security-dir-string ()
  (let ((ein:notebook-console-security-dir "/some/dir/")
        (notebook (ein:notebook-new "DUMMY-URL-OR-PORT" "DUMMY-NOTEBOOK-ID")))
    (should (equal (ein:notebook-console-security-dir-get notebook)
                   ein:notebook-console-security-dir))))

(ert-deftest ein:notebook-console-security-dir-list ()
  (let ((ein:notebook-console-security-dir
         '((8888 . "/dir/8888/")
           ("htttp://dummy.org" . "/dir/http/")
           (default . "/dir/default/"))))
    (let ((notebook (ein:notebook-new 8888 "DUMMY-NOTEBOOK-ID")))
      (should (equal (ein:notebook-console-security-dir-get notebook)
                     "/dir/8888/")))
    (let ((notebook (ein:notebook-new "htttp://dummy.org" "DUMMY-NOTEBOOK-ID")))
      (should (equal (ein:notebook-console-security-dir-get notebook)
                     "/dir/http/")))
    (let ((notebook (ein:notebook-new 9999 "DUMMY-NOTEBOOK-ID")))
      (should (equal (ein:notebook-console-security-dir-get notebook)
                     "/dir/default/")))))

(ert-deftest ein:notebook-console-security-dir-func ()
  (let ((ein:notebook-console-security-dir
         '(lambda (x) (should (equal x "DUMMY-URL-OR-PORT")) "/dir/"))
        (notebook (ein:notebook-new "DUMMY-URL-OR-PORT" "DUMMY-NOTEBOOK-ID")))
    (should (equal (ein:notebook-console-security-dir-get notebook) "/dir/"))))
