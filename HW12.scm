(define (assert-equal v1 v2)
  (if (equal? v1 v2)
    (print 'ok)
    (print (list v2 'does 'not 'equal v1))))


; Derive returns the derivative of exp with respect to var.
(define (derive exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp) (derive-sum exp var))
        ((product? exp) (derive-product exp var))
        ((exponentiation? exp) (derive-exponentiation exp var))
        (else 'Error)))

; Variables are represented as symbols
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

; Numbers are compared with =
(define (=number? exp num)
  (and (number? exp) (= exp num)))

; Sums are represented as lists that start with +.
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))
(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))
(define (addend s) (cadr s))
(define (augend s) (caddr s))

; Products are represented as lists that start with *.
(define (make-product m1 m2)
(cond ((or (=number? m1 0) (=number? m2 0)) 0)
      ((=number? m1 1) m2)
      ((=number? m2 1) m1)
      ((and (number? m1) (number? m2)) (* m1 m2))
      (else (list '* m1 m2))))
(define (product? x)
  (and (pair? x) (eq? (car x) '*)))
(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))

(define (test-sum)
  (assert-equal '(+ a x) (make-sum 'a 'x))
  (assert-equal '(+ a (+ x 1)) (make-sum 'a (make-sum 'x 1)))
  (assert-equal 'x (make-sum 'x 0))
  (assert-equal 'x (make-sum 0 'x))
  (assert-equal 4 (make-sum 1 3)))

(define (test-product)
  (assert-equal '(* a x) (make-product 'a 'x))
  (assert-equal 0 (make-product 'x 0))
  (assert-equal 'x (make-product 1 'x))
  (assert-equal 6 (make-product 2 3)))

;MY CODE
(define (derive-sum exp var)
  (make-sum (derive addend var) (derive augend var)) 
)
;END MY CODE
(define (test-derive-sum)
  (assert-equal 1 (derive '(+ x 3) 'x)))

(test-derive-sum)
;MY CODE
(define (derive-product exp var)
  (make-sum (make-product (derive multiplier var) multiplicand) (make-product multiplier (derive multiplicand var)))
)
;END MY CODE
(define (test-derive-product)
  (assert-equal 'y (derive '(* x y) 'x))
  (assert-equal '(+ (* x y) (* y (+ x 3)))
                (derive '(* (* x y) (+ x 3)) 'x)))

(test-derive-product)

;MY CODE
; Exponentiations are represented as lists that start with ^.
(define (make-exponentiation base exponent)
  (cond ((or (=number? base 0) (=number? base 1)) base)
        ((=number? exponent 1) base)
        ((=number? exponent 0) 1)
        (else (list '^ base exponent)) 
  )
)

(define (base exponentiation)
  (cadr exponentiation)
)

(define (exponent exponentiation)
  (caddr exponentiation)
)

(define (exponentiation? exp)
  (and (pair? exp) (eq? (car exp) '^))
)
;END MY CODE

(define (test-exponentiation)
  (let ((x^2 (make-exponentiation 'x 2)))
    (assert-equal 'x (make-exponentiation 'x 1))
    (assert-equal 1  (make-exponentiation 'x 0))
    (assert-equal 16 (make-exponentiation 2 4))
    (assert-equal '(^ x 2) x^2)
    (assert-equal 'x (base x^2))
    (assert-equal 2  (exponent x^2))
    (assert-equal #t (exponentiation? x^2))
    (assert-equal #f (exponentiation? 1))
    (assert-equal #f (exponentiation? 'x))
  ))

(test-exponentiation)

;MY CODE
(define (derive-exponentiation exp var)
  (make-product (base exp) (make-exponent var (- (exponent exp) 1)))
)
;END MY CODE

(define (test-derive-exponentiation)
  (let ((x^2 (make-exponentiation 'x 2))
        (x^3 (make-exponentiation 'x 3)))
    (assert-equal '(* 2 x) (derive x^2 'x))
    (assert-equal '(* 3 (^ x 2)) (derive x^3 'x))
    (assert-equal '(+ (* 3 (^ x 2)) (* 2 x)) (derive (make-sum x^3 x^2) 'x))
  ))

(test-derive-exponentiation)

(define (exp-recursive b n)
  (if (= n 0)
      1
      (* b (exp-recursive b (- n 1)))))

(define (exp-recursive b n)
  (if (= n 0)
      1
      (* b (exp-recursive b (- n 1)))))

;MY CODE
(define (exp-aux b n acc)
  (if (= n 0)
      acc
      (exp-aux b (- n 1) (* b acc)) 
(define (exp b n)
  (exp-aux b n 1)
)
;END MY CODE

(define (test-exp)
  (assert-equal 8 (exp 2 3))
  (assert-equal 1 (exp 9.137 0))
  (assert-equal 1024 (exp 4 5))
  (assert-equal 6.25 (exp 2.5 2))
  ;; A test that would break STk if this was not tail recursive.
  ;; The output is humongous, so we don't print out the entire output
  ;; Instead we just get the last two digits.
  (assert-equal 56 (remainder (exp 2 (exp 2 15)) 100)))

(test-exp)