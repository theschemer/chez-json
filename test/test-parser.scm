(import (chez-json json)
        (srfi s64 testing))

;; Numbers
(test-begin "numbers")
;; (test-equal 1234 (json-string->scm "1234"))
;; (test-equal -1234 (json-string->scm "-1234"))
;; (test-equal -54.897 (json-string->scm "-54.897"))
(test-equal 1000.0 (json-string->scm "1e3"))
(test-equal 0.001 (json-string->scm "1E-3"))
(test-end "numbers")

;; Strings
(test-begin "strings")
(test-equal "hello guile!" (json-string->scm "\"hello guile!\""))
;; (test-equal "你好 guile!" (json-string->scm "\"你好 guile!\""))
;; (test-equal "你好 guile!" (json-string->scm "\"\\u4f60\\u597d guile!\""))
(test-end "strings")

;; Boolean
(test-begin "boolean")
(test-equal #t (json-string->scm "true"))
(test-equal #f (json-string->scm "false"))
(test-end "boolean")

;; Null
(test-begin "null")
(test-equal '() (json-string->scm "null"))
(test-end "null")

;; Lists; guile version had section for arrays, but guenchi's port uses lists
(test-begin "lists")
;; (test-equal #() (json-string->scm "[]"))
(test-equal '(1 2 3 4) (json-string->scm "[1,2,3,4]"))
(test-equal '(1 2 3 4) (json-string->scm "[   1,2, 3,4  ]"))
(test-equal '(1 2 (3 4) (5 6 (7 8))) (json-string->scm "[1,2,[3,4],[5,6,[7,8]]]" ))
(test-equal '(1 "two" 3 "four") (json-string->scm "[1,\"two\",3,\"four\"]"))
;; (test-error #t (json-string->scm "[1,2,,,5]")) 
(test-end "lists")

;; (define (hashtable-equal? ht1 ht2)
;;   (and (equal? (hashtable-keys ht1)
;;                (hashtable-keys ht2))
;;        (equal? (hashtable-values ht1)
;;                (hashtable-values ht2))))

(define (make-hashtable-set key values)
  (define ht (make-hashtable equal-hash equal?))
  (hashtable-set! ht key values)
  ht)

;; Objects
(test-begin "objects")
(test-equal (hashtable-values (make-hashtable-set "foo" "bar"))
  (hashtable-values (json-string->scm "{\"foo\":\"bar\"}")))
(test-equal (hashtable-values (make-hashtable-set "foo" '(1 2 3)))
  (hashtable-values (json-string->scm "{\"foo\":[1,2,3]}")))
(define ht1 (make-hashtable-set "foo" (make-hashtable-set "bar" '(1 2 3))))
(define ht1_test (json-string->scm "{\"foo\":{\"bar\":[1,2,3]}}"))
(test-equal (hashtable-values (hashtable-ref ht1 "foo" -999))
  (hashtable-values (hashtable-ref ht1_test "foo" -999)))
(define ht2 (make-hashtable equal-hash equal?))
(hashtable-set! ht2 "price" 29.99)
(hashtable-set! ht2 "author" "An author")
(hashtable-set! ht2 "title" "A book")
(define ht2_test (json-string->scm "{\"title\":\"A book\",\"author\":\"An author\",\"price\":29.99}"))

;; (test-equal '(("foo" . #(1 (("two" . "three"))))) (json-string->scm "{\"foo\":[1,{\"two\":\"three\"}]}"))
(test-end "objects")

;; Since the following JSON object contains more than one key-value pair, we
;; can't use "test-equal" directly since the output could be unordered.
;; (define book (json-string->scm "{\"title\":\"A book\",\"author\":\"An author\",\"price\":29.99}"))
;; (test-equal "A book" (assoc-ref book "title"))
;; (test-equal "An author" (assoc-ref book "author"))
;; (test-equal 29.99 (assoc-ref book "price"))

(exit (if (zero? (test-runner-fail-count (test-runner-get))) 0 1))
