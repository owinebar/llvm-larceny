; Copyright 2007 William D Clinger
;
; $Id$
;
; Larceny -- R6RS-compatible I/O system.

; FIXME:  These are supposed to be syntax,
; but I'm hoping they go away before the R6RS is ratified.

(define (file-options . args) '())    ; FIXME

; FIXME: not yet implemented, because I hope it goes away
;     buffer-mode

(define (buffer-mode? mode)
  (case mode
   ((none line block) #t)
   (else #f)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Transcoders et cetera.
; For representations, see iosys.sch
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (latin-1-codec) 'latin-1)
(define (utf-8-codec) 'utf-8)
(define (utf-16-codec) 'utf-16)

; FIXME: not yet implemented, because I hope it goes away
;     eol-style

(define (native-eol-style) 'none)   ; FIXME: for backward compatibility

; FIXME:  &i/o-decoding, &i/o-encoding, and their associated
; operations aren't yet implemented because the raise mode
; no longer makes sense.  A formal comment has been submitted.

; FIXME: not yet implemented, because I hope it goes away
;     error-handling-mode

(define (make-transcoder codec . rest)
  (cond ((null? rest)
         (io/make-transcoder codec (native-eol-style) 'raise))
        ((null? (cdr rest))
         (io/make-transcoder codec (car rest) 'raise))
        ((null? (cddr rest))
         (io/make-transcoder codec (car rest) (cadr rest)))
        (else
         (assertion-violation 'make-transcoder
                              "wrong number of arguments"
                              (cons codec rest)))))

(define (native-transcoder)
  (make-transcoder (latin-1-codec) 'none 'ignore))

(define (transcoder-codec t)
  (case (fxrshl t 5)
   ((1) 'latin-1)
   ((2) 'utf-8)
   ((3) 'utf-16)
   (else (assertion-violation 'transcoder-codec
                              "weird transcoder" t))))

(define (transcoder-eol-style t)
  (case (fxlogand (fxrshl t 2) 7)
   ((0) 'none)
   ((1) 'lf)
   ((2) 'nel)
   ((3) 'ls)
   ((4) 'cr)
   ((5) 'crlf)
   ((6) 'crnel)
   (else (assertion-violation 'transcoder-eol-style
                              "weird transcoder" t))))

(define (transcoder-error-handling-mode t)
  (case (fxlogand t 3)
   ((0) 'raise)
   ((1) 'replace)
   ((2) 'ignore)
   (else (assertion-violation 'transcoder-error-handling-mode
                              "weird transcoder" t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Operations on ports.
; R5RS operations are in stdio.sch
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (port-transcoder p) (io/port-transcoder p))

(define (textual-port? p) (io/textual-port? p))

(define (binary-port? p) (io/binary-port? p))

(define (transcoded-port p t)
  (if (and (binary-port? p)
           (memq (transcoder-codec t) '(latin-1 utf-8))
           (eq? (transcoder-eol-style t) 'none)
           (eq? (transcoder-error-handling-mode t) 'ignore))
      (io/transcoded-port p t)
      (assertion-violation 'transcoded-port
                           "bad port or unsupported transcoder" p t)))

; FIXME:  For now, all binary and textual ports support port-position.

(define (port-has-port-position? p)
  (or (binary-port? p) (textual-port? p)))

(define (port-position p) (io/port-position p))

; FIXME:  For now, no ports support set-port-position!.

(define (port-has-set-port-position!? p) #f)

(define (set-port-position! p pos)
  (assertion-violation 'set-port-position! "not yet implemented"))

(define (close-port p)
  (io/close-port p))

(define (call-with-port p f)
  (call-with-values
   (lambda () (f p))
   (lambda results
     (if (io/open-port? p) (io/close-port p))
     (apply values results))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Input ports.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FIXME: input-port? is defined elsewhere.

(define (port-eof? p)
  (assert (io/input-port? p))
  (cond ((binary-port? p)
         (eof-object? (lookahead-u8 p)))
        ((textual-port? p)
         (eof-object? (lookahead-char p)))
        (else
         ; probably closed
         #f)))

; FIXME: fakes file options

(define (open-file-input-port filename . rest)
  (cond ((null? rest)
         (io/open-file-input-port filename '() 'block #f))
        ((null? (cdr rest))
         (io/open-file-input-port filename (car rest) 'block #f))
        ((null? (cddr rest))
         (io/open-file-input-port filename (car rest) (cadr rest) #f))
        ((null? (cdddr rest))
         (io/open-file-input-port filename
                                  (car rest) (cadr rest) (caddr rest)))
        (else
         (assertion-violation 'open-file-input-port
                              "wrong number of arguments"
                              (cons filename rest)))))

(define (open-bytevector-input-port bv . rest)
  (let ((transcoder (if (null? rest) #f (car rest)))
        (port (bytevector-io/open-input-bytevector bv)))
    (if transcoder
        (transcoded-port port transcoder)
        port)))

(define (open-string-input-port s)
  (let ((transcoder (make-transcoder (utf-8-codec) 'none 'ignore))
        (port (bytevector-io/open-input-bytevector-no-copy (string->utf8 s))))
    (transcoded-port port transcoder)))

; FIXME: not implemented yet

(define (standard-input-port)
  (assertion-violation 'standard-input-port "not yet implemented"))

; FIXME: current-input-port is implemented elsewhere

; FIXME: not implemented yet

(define (make-custom-binary-input-port
         id read! get-position set-position! close)
  (assertion-violation 'make-custom-binary-input-port "not yet implemented"))

; FIXME: not implemented yet

(define (make-custom-textual-input-port
         id read! get-position set-position! close)
  (assertion-violation 'make-custom-textual-input-port "not yet implemented"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Basic input (way incomplete)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (lookahead-u8 p)   (io/get-u8 p #t))
(define (get-u8 p)         (io/get-u8 p #f))
(define (lookahead-char p) (io/get-char p #t))
(define (get-char p)       (io/get-char p #f))

; FIXME: not yet implemented
;     get-bytevector-n
;     get-bytevector-n!
;     get-bytevector-some
;     get-bytevector-all
;     get-string-n
;     get-string-n!
;     get-string-all
;     get-line