; Copyright 1991 Lightship Software
;
; $Id$
;
; Larceny library -- list procedures.
;
; Procedures of the form x->list and list->x can be found in the file for x.

($$trace "list")

(define caar (lambda (x) (car (car x))))
(define cadr (lambda (x) (car (cdr x))))
(define cdar (lambda (x) (cdr (car x))))
(define cddr (lambda (x) (cdr (cdr x))))
(define caaar (lambda (x) (car (car (car x)))))
(define caadr (lambda (x) (car (car (cdr x)))))
(define cadar (lambda (x) (car (cdr (car x)))))
(define caddr (lambda (x) (car (cdr (cdr x)))))
(define cdaar (lambda (x) (cdr (car (car x)))))
(define cdadr (lambda (x) (cdr (car (cdr x)))))
(define cddar (lambda (x) (cdr (cdr (car x)))))
(define cdddr (lambda (x) (cdr (cdr (cdr x)))))
(define caaaar (lambda (x) (car (car (car (car x))))))
(define caaadr (lambda (x) (car (car (car (cdr x))))))
(define caadar (lambda (x) (car (car (cdr (car x))))))
(define caaddr (lambda (x) (car (car (cdr (cdr x))))))
(define cadaar (lambda (x) (car (cdr (car (car x))))))
(define cadadr (lambda (x) (car (cdr (car (cdr x))))))
(define caddar (lambda (x) (car (cdr (cdr (car x))))))
(define cadddr (lambda (x) (car (cdr (cdr (cdr x))))))
(define cdaaar (lambda (x) (cdr (car (car (car x))))))
(define cdaadr (lambda (x) (cdr (car (car (cdr x))))))
(define cdadar (lambda (x) (cdr (car (cdr (car x))))))
(define cdaddr (lambda (x) (cdr (car (cdr (cdr x))))))
(define cddaar (lambda (x) (cdr (cdr (car (car x))))))
(define cddadr (lambda (x) (cdr (cdr (car (cdr x))))))
(define cdddar (lambda (x) (cdr (cdr (cdr (car x))))))
(define cddddr (lambda (x) (cdr (cdr (cdr (cdr x))))))


(define (list . x) x)

(define (list* . elements)
  (define (loop more)
    (cond ((pair? (cdr more)) (cons (car more) (loop (cdr more))))
          ((null? (cdr more)) (car more))
          (else (error "list*:  Improper list" more))))

  (cond ((pair? elements) (cond ((pair? (cdr elements)) (loop elements))
                                ((null? (cdr elements)) (car elements))
                                (else (error "list*:  Improper list" elements))))
        ((null? elements) '())
        (else (error "list*:  Improper list" elements))))

(define (length l)

  (define (loop l len)
    (if (pair? l)
	(loop (cdr l) (+ len 1))
	len))

  (loop l 0))

;; #t if L is a proper list of the correct length
(define (length=? l n)
  (cond ((> n 0) (cond ((pair? l) (length=? (cdr l) (- n 1)))
                       ((null? l) #f)
                       (else (error "length=?: Improper list" l))))
        ((zero? n) (cond ((pair? l) #f)
                         ((null? l) #t)
                         (else (error "length=?: Improper list" l))))
        (else (error "length=?: negative n" n))))

;; #t if L is a list longer than N elements
(define (length>? l n)
  (cond ((> n 0) (cond ((pair? l) (length>? (cdr l) (- n 1)))
                       ((null? l) #f)
                       (else (error "length>?: Improper list" l))))
        ((zero? n) (cond ((pair? l) #t)
                         ((null? l) #f)
                         (else (error "length>?: Improper list" l))))
        (else (error "length>?: negative n" n))))

;; #t if L is a list N or more elements long
(define (length>=? l n)
  (cond ((> n 0) (cond ((pair? l) (length>=? (cdr l) (- n 1)))
                       ((null? l) #f)
                       (else (error "length>?: Improper list" l))))
        ((zero? n) (cond ((pair? l) #t)
                         ((null? l) #t)
                         (else (error "length>?: Improper list" l))))
        (else (error "length>=?: negative n" n))))

;; #t if L is a list shorter than N elements
(define (length<? l n)
  (cond ((> n 0) (cond ((pair? l) (length<? (cdr l) (- n 1)))
                       ((null? l) #t)
                       (else (error "length<?: Improper list" l))))
        ((zero? n) #f)
        (else (error "length<?: negative n" n))))

;; #t if L is a list no longer than N elements
(define (length<=? l n)
  (cond ((> n 0) (cond ((pair? l) (length<=? (cdr l) (- n 1)))
                       ((null? l) #t)
                       (else (error "length<=?: Improper list" l))))
        ((zero? n) (cond ((pair? l) #f)
                         ((null? l) #t)
                         (else (error "length<=?: Improper list" l))))
        (else (error "length<=?: negative n" n))))

;; #t if left is a shorter list than right
(define (shorter? left right)
  (cond ((pair? left) (cond ((pair? right) (shorter? (cdr left) (cdr right)))
                            ((null? right) #f)
                            (else (error "shorter?: Improper list" right))))
        ((null? left) (cond ((pair? right) #t)
                            ((null? right) #f)
                            (else (error "shorter?: Improper list" right))))
        (else (error "shorter?:  Improper list" left))))

;; #t if left is a longer list than right
(define (longer? left right)
  (cond ((pair? left) (cond ((pair? right) (longer? (cdr left) (cdr right)))
                            ((null? right) #t)
                            (else (error "longer?: Improper list" right))))
        ((null? left) (cond ((pair? right) #f)
                            ((null? right) #f)
                            (else (error "longer?: Improper list" right))))
        (else (error "longer?: Improper list" left))))

(define (map f x . rest)

  (define (map1 f x)
    (if (pair? x)
	(cons (f (car x)) (map1 f (cdr x)))
	'()))

  (define (map2 f x y)
    (if (pair? x)
	(cons (f (car x) (car y))
	      (map2 f (cdr x) (cdr y)))
	'()))

  (define (map3 f x y z)
    (if (pair? x)
	(cons (f (car x) (car y) (car z))
	      (map3 f (cdr x) (cdr y) (cdr z)))
	'()))

  (define (map4 f x y z w)
    (if (pair? x)
	(cons (f (car x) (car y) (car z) (car w))
	      (map4 f (cdr x) (cdr y) (cdr z) (cdr w)))
	'()))

  (define (mapn f lists)
    (if (pair? (car lists))
	(cons (apply f (map1 car lists))
	      (mapn f (map1 cdr lists)))
	'()))

  (case (length rest)
    ((0)  (map1 f x))
    ((1)  (map2 f x (car rest)))
    ((2)  (map3 f x (car rest) (cadr rest)))
    ((3)  (map4 f x (car rest) (cadr rest) (caddr rest)))
    (else (mapn f (cons x rest)))))


(define (for-each f x . rest)

  (define (map1 f x)
    (if (pair? x)
	(cons (f (car x)) (map1 f (cdr x)))
	'()))

  (define (for-each1 f x)
    (if (pair? x)
	(begin (f (car x))
	       (for-each1 f (cdr x)))
	(unspecified)))

  (define (for-each2 f x y)
    (if (pair? x)
	(begin (f (car x) (car y))
	       (for-each2 f (cdr x) (cdr y)))
	(unspecified)))

  (define (for-each3 f x y z)
    (if (pair? x)
	(begin (f (car x) (car y) (car z))
	       (for-each3 f (cdr x) (cdr y) (cdr z)))
	(unspecified)))

  (define (for-each4 f x y z w)
    (if (pair? x)
	(begin (f (car x) (car y) (car z) (car w))
	       (for-each4 f (cdr x) (cdr y) (cdr z) (cdr w)))
	(unspecified)))

  (define (for-each-n f lists)
    (if (pair? (car lists))
	(begin (apply f (map1 car lists))
	       (for-each-n f (map1 cdr lists)))
	(unspecified)))

  (case (length rest)
    ((0)  (for-each1 f x))
    ((1)  (for-each2 f x (car rest)))
    ((2)  (for-each3 f x (car rest) (cadr rest)))
    ((3)  (for-each4 f x (car rest) (cadr rest) (caddr rest)))
    (else (for-each-n f (cons x rest)))))

(define reverse
  (letrec ((reverse-loop
	    (lambda (l1 l2)
	      (if (pair? l1)
		  (reverse-loop (cdr l1) (cons (car l1) l2))
		  l2))))
    (lambda (l)
      (reverse-loop l '()))))


;; Reverse L while appending to R.  Although this looks like an
;; unusual thing to want to do, it comes in quite handy in a lot of
;; code.

; Probably due to JonL White.
(define (revappend! l r)
  (define (loop0 prev curr next)
    (set-cdr! curr prev)
    (if (pair? next)
        (loop1 (cdr next) curr next)
        curr))
  (define (loop1 next prev curr)
    (set-cdr! curr prev)
    (if (pair? next)
        (loop2 next (cdr next) curr)
        curr))
  (define (loop2 curr next prev)
    (set-cdr! curr prev)
    (if (pair? next)
        (loop0 curr next (cdr next))
        curr))
  (if (pair? l)
      (loop0 r l (cdr l))
      r))

(define (reverse! l)
  (revappend! l '()))

(define (filter predicate list)
  (define (loop scan accepted)
    (cond ((pair? scan) (loop (cdr scan)
                              (if (predicate (car scan))
                                  (cons (car scan) accepted)
                                  accepted)))
          ((null? scan) (reverse! accepted))
          (else (error "filter: Improper list" list))))
  (loop list '()))

(define (find-if pred list)
  (cond ((pair? list) (if (pred (car list))
                          (car list)
                          (find-if pred (cdr list))))
        ((null? list) #f)
        (else (error "find-if: Improper list" list))))

(define (foldl f init l)
  (define (fold-one accum tail)
    (cond ((pair? tail) (fold-one (f accum (car tail)) (cdr tail)))
          ((null? tail) accum)
          (else (error "foldl: Improper list" l))))
  (fold-one init l))

(define (foldr f init l)
  (define (fold-one accum tail)
    (cond ((pair? tail) (f (car tail) (fold-one accum (cdr tail))))
          ((null? tail) accum)
          (else (error "foldr: Improper list" l))))
  (fold-one init l))

(define (append . args)

  (define (loop rest tail)
    (cond ((null? rest)
	   tail)
	  ((null? (car rest))
	   (loop (cdr rest) tail))
	  (else
	   (loop (cdr rest)
                 (call-with-values
                  (lambda ()
                    (list-copy2 (car rest)))
                  (lambda (new-head new-tail)
                    (set-cdr! new-tail tail)
                    new-head))))))

  (if (pair? args)
      (let ((a (reverse! args)))
	(loop (cdr a) (car a)))
      '()))


(define (append! . args)

  (define (loop rest tail)
    (cond ((null? rest)
	   tail)
	  ((null? (car rest))
	   (loop (cdr rest) tail))
	  (else
	   (loop (cdr rest)
		 (begin (set-cdr! (last-pair (car rest)) tail)
			(car rest))))))

  (if (pair? args)
      (let ((a (reverse! args)))
	(loop (cdr a) (car a)))
      '()))


(define (list-head elements n)
  (define (loop segment i tail)
    (cond ((>= i n) (reverse! segment))
          ((pair? tail) (loop (cons (car tail) segment) (+ i 1) (cdr tail)))
          (else (error "list-head: improper list" tail))))
  (loop '() 0 elements))

(define (list-tail x k)

  (define (list-tail x k)
    (if (zero? k)
	x
	(list-tail (cdr x) (- k 1))))

  (list-tail x k))


(define (list-ref x k)
  (car (list-tail x k)))

(define (position-of x lst)
  (let loop ((i 0) (l lst))
    (if (pair? l)
        (if (eq? x (car l))
            i
            (loop (+ i 1) (cdr l)))
        #f)))

(define (list-set! l n o)
  (set-car! (list-tail l n) o))


(define (last-pair l)
  (if (pair? (cdr l))
      (last-pair (cdr l))
      l))

(define (last l)
  (car (last-pair l)))

(define (set-last! l x)
  (set-car! (last-pair l) x))

; This is pretty much optimal for Larceny.

(define (list-copy l)
  (define (loop l prev)
    (if (pair? l)
	(let ((q (cons (car l) '())))
	  (set-cdr! prev q)
	  (loop (cdr l) q))
	#t))
  (if (pair? l)
      (let ((first (cons (car l) '())))
	(loop (cdr l) first)
	first)
      l))


; Returns both the first and last pairs of the argument, or (),() if the
; argument is ().

(define (list-copy2 l)
  (define (loop l prev)
    (if (pair? l)
	(let ((q (cons (car l) '())))
	  (set-cdr! prev q)
	  (loop (cdr l) q))
	prev))
  (if (pair? l)
      (let ((first (cons (car l) '())))
	(values first (loop (cdr l) first)))
      (values l l)))


(define member
  (letrec ((member
	    (lambda (x l)
              (cond ((pair? l) (if (equal? x (car l))
                                   l
                                   (member x (cdr l))))
                    ((null? l) #f)
                    (else (error "member: Improper list" l))))))
    (lambda (x l)
      (cond ((symbol? x) (memq x l))
            ((number? x) (memv x l))
            (else (member x l))))))

(define (memv x l)
  (define (memv x l)
    (cond ((pair? l) (if (eqv? x (car l))
                         l
                         (memv x (cdr l))))
          ((null? l) #f)
          (else (error "memv: Improper list" l))))
  (if (symbol? x)
      (memq x l)
      (memv x l)))

(define (memq x l)
  (cond ((pair? l) (if (eq? x (car l))
                       l
                       (memq x (cdr l))))
        ((null? l) #f)
        (else (error "memq: Improper list" l))))

(define assoc-string
  (letrec ((assoc
            (lambda (x l)
              (cond ((pair? l) (if (string-=? x (caar l))
                                   (car l)
                                   (assoc x (cdr l))))
                    ((null? l) #f)
                    (else (error "assoc-string: Improper alist"))))))
    (lambda (x l)
      (if (string? x)
          (assoc x l)
          (error "assoc-string: not a string" x)))))

(define assoc-string-ci
  (letrec ((assoc
            (lambda (x l)
              (cond ((pair? l) (if (string-ci=? x (caar l))
                                   (car l)
                                   (assoc x (cdr l))))
                    ((null? l) #f)
                    (else (error "assoc-string-ci: Improper alist"))))))
    (lambda (x l)
      (if (string? x)
          (assoc x l)
          (error "assoc-string-ci: not a string" x)))))

(define assoc
  (letrec ((assoc
	    (lambda (x l)
              (cond ((pair? l) (if (equal? x (caar l))
                                   (car l)
                                   (assoc x (cdr l))))
                    ((null? l) #f)
                    (else (error "assoc: Improper alist" l))))))
    (lambda (x l)
      (cond ((symbol? x) (assq x l))
            ((number? x) (assv x l))
            (else (assoc x l))))))

(define (assv x l)
  (define (assv x l)
    (if (pair? l)
        (if (eqv? (caar l) x)
            (car l)
            (assv x (cdr l)))
        #f))
  (if (symbol? x)
      (assq x l)
      (assv x l)))

(define (assq x l)
  (if (pair? l)
      (if (eq? (caar l) x)
          (car l)
          (assq x (cdr l)))
      #f))

(define (remove x l)
  (cond ((not (pair? l)) l)
	((equal? x (car l)) (remove x (cdr l)))
	(else (cons (car l) (remove x (cdr l))))))


(define (remv x l)
  (cond ((not (pair? l)) l)
	((eqv? x (car l)) (remv x (cdr l)))
	(else (cons (car l) (remv x (cdr l))))))


(define (remq x l)
  (cond ((not (pair? l)) l)
	((eq? x (car l)) (remq x (cdr l)))
	(else (cons (car l) (remq x (cdr l))))))


(define (remq! key list)
  (cond ((null? list) list)
	((eq? key (car list))
	 (remq! key (cdr list)))
	(else
	 (set-cdr! list (remq! key (cdr list)))
	 list)))


(define (remv! key list)
  (cond ((null? list) list)
	((eqv? key (car list))
	 (remv! key (cdr list)))
	(else
	 (set-cdr! list (remv! key (cdr list)))
	 list)))


(define (remove! key list)
  (cond ((null? list) list)
	((equal? key (car list))
	 (remove! key (cdr list)))
	(else
	 (set-cdr! list (remove! key (cdr list)))
	 list)))


(define (list? x)
  (define (loop2 slow fast)
    (cond ((eq? fast slow) #f)
          ((pair? fast) (loop1 (cdr slow) (cdr fast)))
          ((null? fast) #t)
          (else #f)))

  (define (loop1 slow fast)
    (cond ((eq? fast slow) #f)
          ((pair? fast) (loop2 slow (cdr fast)))
          ((null? fast) #t)
          (else #f)))

  (cond ((pair? x) (loop1 x (cdr x)))
        ((null? x) #t)
        (else #f)))

(define (every? p l . ls)

  (define (every1 a)
    (if (pair? a)
        (and (p (car a))
             (every1 (cdr a)))
        #t))

  (define (every2 a b)
    (cond ((null? (cdr a)) (p (car a) (car b)))
	  ((p (car a) (car b)) (every2 (cdr a) (cdr b)))
	  (else #f)))

  (define (every3 a b c)
    (cond ((null? (cdr a)) (p (car a) (car b) (car c)))
	  ((p (car a) (car b) (car c)) (every3 (cdr a) (cdr b) (cdr c)))
	  (else #f)))

  (define (every-n ls)
    (cond ((null? (cdar ls)) (apply p (map car ls)))
          ((apply p (map car ls)) (every-n (map cdr ls)))
          (else #f)))

  (cond ((null? ls) (every1 l))
        ((null? (cdr ls))
         (or (null? l) (every2 l (car ls))))
        ((null? (cddr ls))
         (or (null? l) (every3 l (car ls) (cadr ls))))
        (else
         (or (null? l) (every-n (cons l ls))))))


(define (some? p l . ls)

  (define (some1 a)
    (and (pair? a)
         (or (p (car a))
             (some1 (cdr a)))))

  (define (some2 a b)
    (cond ((null? a) #f)
          ((p (car a) (car b)))
          (else (some2 (cdr a) (cdr b)))))

  (define (some3 a b c)
    (cond ((null? a) #f)
          ((p (car a) (car b) (car c)))
          (else (some3 (cdr a) (cdr b) (cdr c)))))

  (define (some-n ls)
    (cond ((null? (car ls)) #f)
          ((apply p (map car ls)))
          (else (some-n (map cdr ls)))))

  (cond ((null? ls) (some1 l))
        ((null? (cdr ls)) (some2 l (car ls)))
        ((null? (cddr ls)) (some3 l (car ls) (cadr ls)))
        (else (some-n (cons l ls)))))

; eof
