
(load "cl-extra") ; makes Emacs Lisp have a greater degree of Common Lisp compatibility

; enable the upcase-region function. (otherwise disabled to avoid confusing n00bs?)
;   http://stackoverflow.com/questions/10026221/enable-all-disabled-commands-permanently
(put 'upcase-region 'disabled nil)

(setq load-path
	(cons "~/.emacs.d/lisp" load-path))

(setq load-path
      ; if you are wondering HOW i got 'M-x j' and 'M-x jj' to do godef jumping, see:
      ; /opt/repos/priv-dots/go-mode_m-x_alias_004575eb128a.patch
	(cons "/opt/repos/priv-dots/go-mode.el" load-path))

(setq load-path
      (cons "/opt/repos/priv-dots/scala-mode2" load-path))

(setq load-path
      (cons "/opt/repos/priv-dots/sbt-mode" load-path))

; -------------- MAC OS X   PATH STUFF -------------------------------
; The value of environment variable "PATH" is used by emacs when you are running a shell in emacs, similar to when you
; are using a shell in a terminal.
; The exec-path is used by emacs itself to find programs it needs for its features,
; such as spell checking, file compression, compiling, grep, diff, etc.
; (setenv "PATH" (concat (getenv "PATH") ":/sw/bin"))
;(setq exec-path (append exec-path '("/usr/local/bin")))  ; on mac, emacs couldn't find gofmt or dlv without this

(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)
(exec-path-from-shell-copy-env "GOPATH")
; -------------- MAC OS X   PATH STUFF -------------------------------


(setq winmachine1 "BOOTCAMP-W7")

(setq debmachine1 "deb1.m.home")

(setq desktop-restore-eager 25) ; restore N buffers immediately, the rest lazily. [otherwise ALL buffers load by default]
(desktop-save-mode 1)

(setq-default fill-column 80)  ; 80 for google style

(defun dtw ()
	(interactive)
    (delete-trailing-whitespace)
)

(defun mywin ()
  (interactive)
  (set-window-dedicated-p (get-buffer-window "*gud*") nil)
  (delete-other-windows)
  (split-window-horizontally)
)

(defun gmw ()
	(interactive)
	(gdb-many-windows nil)
	;(color-theme-deep-blue)
)

(defun eio ()
  (interactive)
  (switch-to-buffer-other-window "*input/output of *")
  (erase-buffer)
;; >>>>>  NOTE: this "other-window" call **does** appear to put the cursor back where I like <<<<<<<<<<<<<
  (other-window 3)
)

(defun chase-comp ()
  (interactive)
  (when (get-buffer-window "*compilation*")
    (switch-to-buffer-other-window "*compilation*")
    (end-of-buffer)
    (other-window 1))
)

(defun my-gmw-hook ()
  ; make it REALLY (t) dedicated so that no cpp source files are loaded over top of the gdb prompt in gud window
  (set-window-dedicated-p (get-buffer-window "*gud*") t)
)

(add-hook 'gdb-many-windows-hook 'my-gmw-hook)


(defun gddt ()
  (interactive)
  (set-window-dedicated-p (selected-window) t)
)

(require 'go-mode-autoloads)
(require 'go-dlv)

(require 'longlines) ; until i figure out what has replaced this. to read: http://emacs.stackexchange.com/questions/10798/if-longlines-mode-is-removed-in-new-emacs-how-can-i-soft-wrap-the-line-around-t

(require 'fill-column-indicator) ; To toggle, use the command: fci-mode

(require 'show-wspace) ; ~/.emacs.d/show-wspace.el

(require 'dos)
(require 'markdown-mode)
(require 'yaml-mode)

(require 'cc-mode) ; /Applications/Emacs.app/Contents/Resources/lisp/progmodes/cc-mode.elc

(require 'protobuf-mode)
(add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))

(require 'scala-mode2) ; https://github.com/hvesalai/scala-mode2  /opt/repos/priv-dots/scala-mode2
(require 'sbt-mode)

(require 'qml-mode) ; in ~/.emacs.d/ ; qml needed to be required after cc-mode
(add-to-list 'auto-mode-alist '("\\.qml$" . qml-mode))

(require 'window-number)
(window-number-mode)
(window-number-meta-mode)

(defun ttt ()
    (interactive)
    (show-ws-toggle-show-tabs)
)

 ;; do line numbering on left margin
(require 'linum)  ; ~/.emacs.d/linum.el
(global-linum-mode 1)

;; DISABLE backup files.
(setq make-backup-files nil)

(defun revert-no-asking ()
  (interactive)
  (revert-buffer 'ignore-auto 'noconfirm)
)

(setq color-theme-is-global nil) ; so that each FRAME can have own color

; the next line should show a CARET, then a capital X, then r. in a browser and in bash console i only see "r"
(global-set-key (kbd "r") 'revert-no-asking)


(global-set-key (kbd "w") 'browse-url)


; the indent-region function is supposed to have an out-of-the-box key combo, but on my mac it stopped working after OS upgrades
(global-set-key (kbd "\\") 'indent-region)

; i tried it as 'gud-mode-hook , and *local* set-key. but you are not IN the *gud* buffer when you want to use it!
(when (string= system-name debmachine1)
  (global-set-key (kbd "C-x SPC") 'gud-break) ; this WIPES OUT the 'rectangle-mark-mode that C-x SPC defaults to here!

  ; refer to http://stackoverflow.com/q/3473134/10278 and http://stackoverflow.com/q/20226626/10278
  (defadvice gud-display-line (around one-source-window activate)
    "Always use the same window to show source code."
    (let ((buf (get-file-buffer true-file)))
      (when (and buf gdb-source-window)
        (set-window-buffer gdb-source-window buf)))
    (let (split-width-threshold split-width-threshold)
      ad-do-it
      )))

; this showed highlighting of the "selection", which was nice, but it did other weird stuff that "lost" the mark
;(transient-mark-mode t)


; igrep-find uses find to recursively grep a directory
(require 'igrep) ; ~/.emacs.d/igrep.el

; do not remember why i added this
(require 'ring+) ; ~/.emacs.d/ring+.el
(require 'doremi) ; ~/.emacs.d/doremi.el



(require 'color-theme) ; /Applications/Emacs.app/Contents/Resources/site-lisp/color-theme/color-theme.elc
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

(setq doremi-color-themes  '( color-theme-robin-hood
color-theme-deep-blue
color-theme-jonadabian-slate
color-theme-digital-ofs1
color-theme-andreas
color-theme-bharadwaj
color-theme-blue-mood
color-theme-blue-sea
color-theme-calm-forest
color-theme-charcoal-black
color-theme-classic
color-theme-jsc-light
color-theme-gnome2
color-theme-gray30
color-theme-kingsajz
color-theme-gtk-ide
color-theme-high-contrast
color-theme-infodoc
color-theme-jedit-grey
color-theme-marine
color-theme-marquardt
color-theme-pierson
color-theme-scintilla
color-theme-snow
color-theme-snowish
color-theme-xemacs
color-theme-subtle-hacker
color-theme-whateveryouwant
color-theme-wheat
color-theme-xp) )


  (defun doremi-color-themes ()
    "Successively cycle among color themes."
    (interactive)
    (doremi (lambda (newval) (funcall newval) newval) ; update fn - just call theme
            (car (last doremi-color-themes)) ; start with last theme
            nil                           ; ignored
            nil                           ; ignored
            doremi-color-themes))         ; themes to cycle through


(defun my-c-mode-common-hook ()
 ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
 (c-set-offset 'substatement-open 0)
 ;; other customizations can go here

 (setq c++-tab-always-indent t)
 (setq c-basic-offset 4) ;; Default is 2
 (setq c-indent-level 4) ;; Default is 2

 (modify-syntax-entry ?_ "w")

 (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
 (setq tab-width 4)
 (setq indent-tabs-mode nil) ; use spaces only if nil ; at one point i was passing 't'
 (c-toggle-auto-hungry-state 0)
; (auto-fill-mode 1)
; (turn-on-eldoc-mode)
; (gtags-mode 1)
; (hs-minor-mode 1)
 (local-set-key [return] 'newline-and-indent)

 (setq c-cleanup-list  '(empty-defun-braces defun-close-semi))

 (set-fill-column 80) ; 80 for google style

 (font-lock-add-keywords
  nil '(;;  new C++11 keywords. (each string literal is a REGEX)
	("\\<\\(alignof\\|alignas\\|constexpr\\|decltype\\|noexcept\\|nullptr\\|static_assert\\|thread_local\\|override\\|final\\)\\>" . font-lock-keyword-face)
	("\\<\\(char16_t\\|char32_t\\)\\>" . font-lock-keyword-face)
	;; user-defined types (rather project-specific) (kept as an example of how to do this)
	("\\<\\(xstring\\|xchar\\)\\>" . font-lock-type-face)
	))
) ;  end of (defun my-c-mode-common-hook ()

;(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;(require 'hacked-wrecked-google-c-style)
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-hook 'c-mode-common-hook 'fci-mode)

(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ipp?$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . c++-mode))

(require 'find-file) ;; for the "cc-other-file-alist" variable
(nconc (cadr (assoc "\\.h\\'" cc-other-file-alist)) '(".m" ".mm"))
(add-to-list 'cc-other-file-alist '("\\.m\\'" (".h")))
(add-to-list 'cc-other-file-alist '("\\.mm\\'" (".h")))


(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

(defun my-python-mode-common-hook ()
  ; i went nuts and pasted in anything about tabs that i found.
  ; at some point i should find out if all these symbols even exist or not
  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq py-tab-width 4)
  (setq tab-always-indent t)
  (setq py-tab-always-indent t)
  (setq py-basic-offset 4) ;; Default is 2
  (setq py-indent-level 4) ;; Default is 2
  (setq indent-tabs-mode nil) ; use spaces only if nil ; at one point i was passing 't'
  (set-variable 'py-indent-offset 4)
;(set-variable 'py-smart-indentation nil)
  (set-variable 'indent-tabs-mode nil)
) ; end of (defun my-python-mode-common-hook ()

(add-hook 'python-mode-hook 'my-python-mode-common-hook)

; BAZEL BUILD syntax highlights like python:
(add-to-list 'auto-mode-alist '("\\.bzl$" . python-mode))
(add-to-list 'auto-mode-alist '("BUILD$" . python-mode))

(defun my-protobuf-mode-common-hook ()
  ; i went nuts and pasted in anything about tabs that i found.
  ; at some point i should find out if all these symbols even exist or not
  (setq tab-width 2)
  (setq c-tab-width 2)
  (setq tab-always-indent t)
  (setq c-tab-always-indent t)
  (setq c-basic-offset 2)
  (setq c-indent-level 2)
  (setq indent-tabs-mode nil) ; use spaces only if nil ; at one point i was passing 't'
  (set-variable 'c-indent-offset 2)
  (set-variable 'indent-tabs-mode nil)
) ; end of (defun my-protobuf-mode-common-hook ()

(add-hook 'protobuf-mode-hook 'my-protobuf-mode-common-hook)



(defun my-html-mode-common-hook ()
  ; i went nuts and pasted in anything about tabs that i found.
  ; at some point i should find out if all these symbols even exist or not
  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq sgml-basic-offset 4)
  (setq tab-always-indent t)
  (setq indent-tabs-mode nil) ; use spaces only if nil ; at one point i was passing 't'
)  ; end of (defun my-html-mode-common-hook ()

(add-hook 'html-mode-hook 'my-html-mode-common-hook)


(defun my-js-mode-common-hook ()
  ; i went nuts and pasted in anything about tabs that i found.
  ; at some point i should find out if all these symbols even exist or not
  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq js-basic-offset 4)
  (setq js-basic-offset 4)
  (setq tab-always-indent t)
  (setq indent-tabs-mode nil) ; use spaces only if nil ; at one point i was passing 't'
)  ; end of (defun my-js-mode-common-hook ()

(add-hook 'js-mode-hook 'my-js-mode-common-hook)

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)))
(add-hook 'go-mode-hook 'fci-mode)

(defun my-go-mode-settings ()
  (set-fill-column 80)
)
(add-hook 'go-mode-hook 'my-go-mode-settings)


(defun sacha/increase-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (ceiling (* 1.10
                                  (face-attribute 'default :height)))))
(defun sacha/decrease-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (floor (* 0.9
                                  (face-attribute 'default :height)))))
(global-set-key (kbd "C-+") 'sacha/increase-font-size)
(global-set-key (quote [C-kp-add]) 'sacha/increase-font-size)
(global-set-key (quote [67108909]) 'sacha/decrease-font-size) ;; you can still use META minus as usual
(global-set-key (quote [C-kp-subtract]) 'sacha/decrease-font-size)



;(when (eq system-type 'darwin)
;(when (eq system-type 'windows-nt)

; (print (font-family-list))  ; show available fonts

(when (string= system-name winmachine1)
    (color-theme-gnome2)
    (set-face-attribute 'default nil :font  "DejaVu Sans Mono")
    (set-face-attribute 'default nil :height 110)
    (set-frame-size (selected-frame) 277 83)
    (set-frame-position (selected-frame) 5  5))

(when (eq system-type 'darwin)
    (color-theme-robin-hood)
    (set-frame-height (selected-frame) 82)
    (set-frame-width (selected-frame) 306)
    (set-frame-position (selected-frame) 80  58)
    (set-face-attribute 'default nil :height 130))

(when (string= system-name debmachine1)
    (color-theme-gnome2)
    (set-face-attribute 'default nil :font  "DejaVu Sans Mono")
    (set-face-attribute 'default nil :height 110)
    (set-frame-position (selected-frame) 0 0)
    (set-frame-size (selected-frame) 280 67))

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :font  "PT Mono"))

(delete-other-windows)
(split-window-horizontally)

; setting this threshold to nil prevents emacs from opening
; half-height windows when 2 windows already exist in the frame:
;(when (string= system-name winmachine1)  ; Apparently this isn't a platform (win32) thing. it is for newer emacs versions? so i always want to set:
    (setq split-height-threshold nil)

;Toggle Show Paren mode.
;When Show Paren mode is enabled, any matching parenthesis is highlighted
;in `show-paren-style' after `show-paren-delay' seconds of Emacs idle time.
(show-paren-mode 1)

;Toggle Column Number mode.
;With arg, turn Column Number mode on if arg is positive,
;otherwise turn it off.  When Column Number mode is enabled, the
;column number appears in the mode line.
(column-number-mode 1)

; transparency of the background of the window. 100 is totally opaque. 0 is "almost invisible"
;(add-to-list 'default-frame-alist '(alpha . (95)))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(gdb-max-frames 100))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


; READJUST keyboard, since my Mac OS X SYSTEM PREFERENCES do remapping themselves...
(setq mac-command-modifier 'ctrl)

(setq mac-option-modifier 'meta)

; not sure why this suddenly became necessary on mac 10.10:
(global-set-key '[(kp-delete)] 'delete-char)







(setq myuser-compiler-warning-exclusions
      '(
	 "google_tools/gmock/built_libs/include"
	 "3.0.9/built_libs/include/mysql"
	 "external/databaselayer/src"
	 "external/databaselayer/include"
	 "boost/install/include/boost-1_42/boost"
	 "boost/install/include/boost-1_49/boost"
	 "usr/local/Qt-5.1.1/include"
	 "wxWidgets/2.9/include/wx/wxcrtvararg.h"
	 "scons-out/dbg/python_kingdom/mach-o_dylib_flattener.sh"
	 "frame size too large for reliable stack checking"
	 "try reducing the number of local variables"
	 "//////"
	 "/opt/qt/bin/macdeployqt"
	 "ignoring #pragma warning"
	 "src/liblsl/include/lsl_cpp.h"
	 "src/Rand/die.c"
	 "warning C4275: non dll-interface class"
	 "warning C4481: nonstandard extension used: override specifier 'override'"
	 "warning C4996: 'wxDocument::GetPrintableName': was declared deprecated"
	 "boost-1_50\\\\boost\\\\variant\\\\variant.hpp(1247)"
       )
)

; Character 47 is "/" (forward slash), so we are ONLY considering lines that start with "/".
; Other lines will NEVER be copied into our "FILTERED WARNINGS" area.
; The stuff that begins "{ (reduce '+ (map }" is intended to generate a number between 0 and positive infinity.
; If it calculates 0, then that means that the line matched ZERO of the exclusion strings.
; Anything other than zero doesn't exactly give you DETAILS...... it basically just means
; that we need to exclude the line.  What a non-zero value actually gives you is the SUM of ALL one-based
; character positions where an exclusion string was matched.
(defun matches-mywarning-criteria (just-a-line)
    (if (char-equal 47 (car (string-to-list just-a-line) ))
	t
      nil) )

(when (string= system-name winmachine1)
(defun matches-mywarning-criteria (just-a-line)
    (if (char-equal 103 (car (string-to-list just-a-line) )) ; 103 is 'g', the root drive letter for the build
	t
      nil) ))


(defun matches-mywarning-criteriaXX (just-a-line)
  (if (or (string-prefix-p "goland/" just-a-line)
	  (string-prefix-p "drbaldfkgjx" just-a-line)
	  (string-prefix-p "gjtirgr" just-a-line)
	  (string-prefix-p "/home/someone" just-a-line)
	  )
      t
    nil))


(defun custom-analyze-one-compiler-line (just-a-line)
  (progn
    (if (matches-mywarning-criteriaXX just-a-line)
	(if (= 0 (reduce '+ (map 'list (lambda (bad-string) (if (string-match  bad-string just-a-line ) (+ 1 (string-match bad-string  just-a-line  )) 0 ))  myuser-compiler-warning-exclusions  ) ))
	    (progn
	      (end-of-buffer)
	      (insert just-a-line)
	      (insert "\n")
	    )
	    nil)
	nil)
  )
)

; your pointer should be INSIDE THE *compilation* BUFFER before you call this.
; Also, you really only want to call it ONE TIME per compile.  If you call it repeatedly on the same
; buffer you will get more and more duplicates each time, because the outputted lines from the previous
; call are part of the buffer now, and the function cycles over ALL LINES IN THE BUFFER.
(defun myuser-filter-warnings ()
  (interactive)
  (progn
    (toggle-read-only -1)
    (end-of-buffer)
    (setq myuserfilter-header-where (line-number-at-pos))
    (insert "\n-~-~-~-~-~-~-~-~-~-- CUSTOM FILTERED WARNINGS  -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~--\n")
    (map 'list 'custom-analyze-one-compiler-line (split-string (buffer-string) "\n" t ) )
    (goto-line myuserfilter-header-where)
  )
)



(setq-default line-spacing 5) ; putting this next to build commands because i use them all in *scratch*, too

(when (string= system-name winmachine1)
    (setq mybuild-command "build.bat -j8 --retest")
    (setq mybuild-dir "G:/SLX5/SuperLabProject/build/scons/"))

(when (eq system-type 'darwin)
    (setq mybuild-command "./build.sh -j8 --retest")
    (setq mybuild-dir "~/Documents/gitgitgit/SL/one/3_in_1_repo/SuperLabProject/build/scons/"))

(when (string= system-name debmachine1)
    (setq mybuild-command "subsurface/scripts/sbuild.sh")
    (setq mybuild-dir "/home/myself/Documents/SHARED/gitsubsurf/"))

(defun sucompile ()
	(interactive)
	(progn
		(setq save-pre-dir default-directory)
		(setq default-directory mybuild-dir)
		(compile mybuild-command)
		(setq default-directory save-pre-dir)

		; The following is ALMOST correct. The next two calls WOULD do what I want if I could make them WAIT until compilation is DONE.
		;(switch-to-buffer-other-window "*compilation*")
		;(myuser-filter-warnings)
		)
	(chase-comp)
)



;;  based off of ;;; compilation-recenter-end.el --- compilation-mode window recentre
;; URL: http://user42.tuxfamily.org/compilation-recenter-end/index.html
(defmacro compilation-recenter-end--with-selected-window (window &rest body)
  (if (eval-when-compile (fboundp 'with-selected-window))
      `(with-selected-window ,window ,@body)
    `(save-selected-window
       (select-window ,window)
       ,@body)))


(put 'compilation-recenter-end--with-selected-window 'lisp-indent-function 1)


(defun my-routine-to-execute-upon-compile-completion (buffer string)
  ; we have to check for 'compilation-mode because OTHER EMACS FEATURES use the compilation hooks!
  ; That caught me by surprise! but see here: https://lists.gnu.org/archive/html/help-gnu-emacs/2008-08/msg00158.html
  ; From:	Kevin Rodgers
  ; Subject:	Re: compilation/grep buffer advice
  ; Date:	Thu, 07 Aug 2008 21:19:23 -0600
  (if (eq major-mode 'compilation-mode)
  ; the "save-excursion" does not seem to successfully put me back in the file i was editing during compilation.
  ;(save-excursion
    (progn
      (switch-to-buffer-other-window "*compilation*")
      (myuser-filter-warnings)
      ;(shell-command "cp file_a.cpp file_b.cpp")

;; >>>>>  NOTE: this "other-window" call **does** appear to put the cursor back where I like <<<<<<<<<<<<<
      (other-window 1)
  ;)
)))



(defun enable-custom-commands-to-run-after-each-compilation ()
  (cond ((or (eval-when-compile (boundp 'compilation-finish-functions))
             (boundp 'compilation-finish-functions))
         ;; emacs 21 up has list `compilation-finish-functions'
         (add-to-list 'compilation-finish-functions
                      'my-routine-to-execute-upon-compile-completion))
        (t
         ;; xemacs 21 only has the old single `compilation-finish-function'
         (setq compilation-finish-function
               'my-routine-to-execute-upon-compile-completion))))

(add-hook 'compilation-mode-hook 'enable-custom-commands-to-run-after-each-compilation)

;----- start section: server for intellij ------------
; added based on https://spin.atomicobject.com/2014/08/07/intellij-emacs/

;(set-default 'server-socket-dir "~/.emacs.d/server") ; <-- this line made it NOT work

(if (functionp 'window-system)
    (when (and (window-system)
           (>= emacs-major-version 24))
      (server-start)))
;-----   end section: server for intellij ------------

;; keep buffers opened when leaving an emacs client
(setq server-kill-new-buffers nil)

(global-set-key (kbd "C-x SPC") 'gud-break)

;(require 'tramp)
;C-x C-f /sudo::/path/to/file  ; <---- just a note to REMIND me how the syntax for this looks

;C-h l  ; shows keystroke history (command history) that you have been typing

;M-x describe-key ; to find out what is invoked by some key combo

; set-buffer-file-coding-system (to convert a DOS line-ending file to unix) --> type 'utf-8-unix' or 'utf-8-dos'

;   --- find and replace recursively across files in subdirectories:
; dired or find-dired if you need all subdirectories.
; Mark the files you want. (m)  ... or (t) ?
;  dired-do-query-replace-regexp
;
; if you have what you need in buffer list, then:
;  M-x ibuffer  (then press 'h' for help. options given to mark, then regexp, then save)
