;;; completely HACKED-UP and personalized file that BEGAN life as  google-c-style.el


;; For some reason 1) c-backward-syntactic-ws is a macro and 2)  under Emacs 22
;; bytecode cannot call (unexpanded) macros at run time:
(eval-when-compile (require 'cc-defs))

;; Wrapper function needed for Emacs 21 and XEmacs (Emacs 22 offers the more
;; elegant solution of composing a list of lineup functions or quantities with
;; operators such as "add")
(defun google-c-lineup-expression-plus-4 (langelem)
  "Indents to the beginning of the current C expression plus 4 spaces.

This implements title \"Function Declarations and Definitions\"
of the Google C++ Style Guide for the case where the previous
line ends with an open parenthese.

\"Current C expression\", as per the Google Style Guide and as
clarified by subsequent discussions, means the whole expression
regardless of the number of nested parentheses, but excluding
non-expression material such as \"if(\" and \"for(\" control
structures.

Suitable for inclusion in 'c-offsets-alist'."
  (save-excursion
    (back-to-indentation)
    ;; Go to beginning of *previous* line:
    (c-backward-syntactic-ws)
    (back-to-indentation)
    (cond
     ;; We are making a reasonable assumption that if there is a control
     ;; structure to indent past, it has to be at the beginning of the line.
     ((looking-at "\\(\\(if\\|for\\|while\\)\\s *(\\)")
      (goto-char (match-end 1)))
     ;; For constructor initializer lists, the reference point for line-up is
     ;; the token after the initial colon.
     ((looking-at ":\\s *")
      (goto-char (match-end 0))))
    (vector (+ 4 (current-column)))))


(defun feedargs-lineup-expression-plus-4 (langelem)
  "Indents to the beginning of the current C expression plus 4 spaces.

Suitable for inclusion in 'c-offsets-alist'."
  (save-excursion
    (back-to-indentation)

    (c-beginning-of-statement-1)

    (back-to-indentation)

    (vector (+ 4 (current-column)))
) ; end of save-excursion
); end of defun

(defun stop-newlines-for-semicolons ()
  'stop
)

; http://emacswiki.org/emacs/IndentingC


;;;###autoload
(defun hacked-personalized-perhaps-broken-ssstyle ()
  (setq c-recognize-knr-p  nil)
  (setq c-enable-xemacs-performance-kludge-p  t) ; speed up indentation in XEmacs

  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4) ;; Default is 2
  (setq c-indent-level 4) ;; Default is 2
  (setq tab-width 4)
  (c-toggle-hungry-state 1)
  (c-toggle-auto-newline 1)
  (c-toggle-auto-hungry-state 1)

  (modify-syntax-entry ?_ "w")
  (set-fill-column 120)
					;(comment-column . 40) ;  need to test

  (setq c-indent-comment-alist
	(append '((other . (space . 2))) c-indent-comment-alist))
		  ;(end-block . (space . 1))

  (setq indent-tabs-mode  nil)
  (font-lock-add-keywords
   nil '( ;;  new C++11 keywords. (each string literal is a REGEX)
	 ("\\<\\(alignof\\|alignas\\|constexpr\\|decltype\\|noexcept\\|nullptr\\|static_assert\\|thread_local\\|override\\|final\\)\\>" . font-lock-keyword-face)
	 ("\\<\\(char16_t\\|char32_t\\)\\>" . font-lock-keyword-face)
	 ;; user-defined types (rather project-specific) (kept as an example of how to do this)
	 ("\\<\\(xstring\\|xchar\\)\\>" . font-lock-type-face)
	 ))
  (setq c-comment-only-line-offset  0)
  (setq c-hanging-braces-alist
	(append '((defun-open after)
		  (defun-close before after)
		  (class-open after)
		  (class-close before after)
		  (inexpr-class-open after)
		  (inexpr-class-close before)
		  (namespace-open after)
		  (inline-open after)
		  (inline-close before after)
		  (block-open after)
		  (block-close . c-snug-do-while)
		  (extern-lang-open after)
		  (extern-lang-close after)
		  (statement-case-open after)
		  (substatement-open after)) c-hanging-braces-alist))
  (setq c-hanging-colons-alist
	(append '((case-label)
		  (label after)
		  (access-label after)
		  (member-init-intro before)
		  (inher-intro)) c-hanging-colons-alist))

  (setq c-hanging-semi&comma-criteria
	(cons 'stop-newlines-for-semicolons c-hanging-semi&comma-criteria))

;;   (setq c-hanging-semi&comma-criteria
;; 	(append '(c-semi&comma-no-newlines-for-oneline-inliners
;; 		  c-semi&comma-inside-parenlist
;; 		  c-semi&comma-no-newlines-before-nonblanks) c-hanging-semi&comma-criteria))


  (setq c-indent-comments-syntactically-p  t)

  (setq c-cleanup-list
	(append '(brace-else-brace
		  brace-elseif-brace
		  brace-catch-brace
		  empty-defun-braces
		  defun-close-semi
		  list-close-comma
		  scope-operator) c-cleanup-list))

  (setq c-offsets-alist
	(append '((arglist-intro google-c-lineup-expression-plus-4)
		  (arglist-cont-nonempty feedargs-lineup-expression-plus-4)
		  (func-decl-cont . ++)
		  (member-init-intro . ++)
		  (inher-intro . ++)
		  (comment-intro . 0)
		  (arglist-close . c-lineup-arglist)
		  (topmost-intro . 0)
		  (block-open . 0)
		  (inline-open . 0)
		  (substatement-open . 0)
;; 		  (statement-cont
;; 		   .
;; 		   (,(when (fboundp 'c-no-indent-after-java-annotations)
;; 		       'c-no-indent-after-java-annotations)
;; 		    ,(when (fboundp 'c-lineup-assignments)
;; 		       'c-lineup-assignments)
;; 		    ++))
		  (label . /)
		  (case-label . +)
		  (statement-case-open . +)
		  (statement-case-intro . +) ; case w/o {
		  (access-label . /)
		  (innamespace . 0)) c-offsets-alist))
) ;; end defun



;;;###autoload
(defun google-make-newline-indent ()
  "Sets up preferred newline behavior. Not set by default. Meant
  to be added to 'c-mode-common-hook'."
  (interactive)
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (define-key c-mode-base-map [ret] 'newline-and-indent))

(provide 'hacked-wrecked-google-c-style)
;;; google-c-style.el ends here
