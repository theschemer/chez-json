(import (chez-json json)
        (srfi s64 testing))

;; Numbers
(test-begin "numbers")
(test-equal "1234" (scm->json-string 1234))
(test-equal "-1234" (scm->json-string -1234))
(test-equal "-54.897" (scm->json-string -54.897))
(test-equal "1000.0" (scm->json-string 1e3))
(test-equal "0.001" (scm->json-string 1e-3))
(test-equal "0.5" (scm->json-string 1/2))
(test-equal "0.75" (scm->json-string 3/4))
;; (test-error #t (scm->json-string 1+2i))
;; (test-error #t (scm->json-string +inf.0))
;; (test-error #t (scm->json-string -inf.0))
;; (test-error #t (scm->json-string +nan.0))
(test-end "numbers")

;; Strings
(test-begin "strings")
(test-equal "\"hello guile!\"" (scm->json-string "hello guile!"))
;; (test-equal "\"你好 guile!\"" (scm->json-string "你好 guile!"))
(test-equal "\"\\u4F60\\u597D guile!\"" (scm->json-string "你好 guile!"))
(test-equal "\"</script>\"" (scm->json-string "</script>"))
(test-equal "\"<\\/script>\"" (scm->json-string "</script>" #t #f))
(test-end "strings")

;; Boolean
(test-begin "boolean")
(test-equal "true" (scm->json-string #t))
(test-equal "false" (scm->json-string #f))
(test-end "boolean")

;; Null
(test-begin "null")
(test-equal "null" (scm->json-string '())) ;; null is empty list in Chez; doesn't have Guile's #nil
(test-end "null")

;; Lists; guile version had section for arrays, but guenchi's port uses lists 
(test-begin "lists")
;; (test-equal "[]" (scm->json-string #()))
(test-equal "[1, 2, 3, 4]" (scm->json-string '(1 2 3 4)))
(test-equal "[1, 2, [3, 4], [5, 6, [7, 8]]]" (scm->json-string '(1 2 (3 4) (5 6 (7 8)))))
(test-equal "[1, \"two\", 3, \"four\"]" (scm->json-string '(1 "two" 3 "four")))
(test-end "lists")

;; Objects
(test-begin "objects")
(test-equal "{\"foo\" : \"bar\"}" (scm->json-string '((foo . bar))))
(test-equal "{\"foo\" : \"bar\"}" (scm->json-string '(("foo" . "bar"))))
(test-equal "{\"foo\" : [1, 2, 3]}" (scm->json-string '((foo . (1 2 3)))))
(test-equal "{\"foo\" : {\"bar\" : [1, 2, 3]}}" (scm->json-string '((foo . ((bar . (1 2 3)))))))
(test-equal "{\"foo\" : [1, {\"two\" : \"three\"}]}" (scm->json-string '((foo . (1 (("two" . "three")))))))
(test-equal "{\"title\" : \"A book\",\"author\" : \"An author\",\"price\" : 29.99}"
  (scm->json-string '((title . "A book")
                      (author . "An author")
                      (price . 29.99))))
(test-end "objects")

;; Empty objects
;; (test-begin "empty-objects")
;; (test-equal "{}" (scm->json-string '()))
;; (test-equal "{\"top-level\":{\"second-level\":{}}}"
;;   (scm->json-string '(("top-level" ("second-level")))))
;; (test-end "empty-objects")

;; Invalid objects
;; (test-begin "invalid-objects")
;; (test-error #t (scm->json (vector 1 2 3 #u8(1 2 3))))
;; (test-error #t (scm->json #u8(1 2 3)))
;; (test-error #t (scm->json #(1 +inf.0 3)))
;; (test-error #t (scm->json '((foo . +nan.0))))
;; (test-end "invalid-objects")

(exit (if (zero? (test-runner-fail-count (test-runner-get))) 0 1))
