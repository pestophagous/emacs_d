
(load "cl-extra") ; makes Emacs Lisp have a greater degree of Common Lisp compatibility

; enable the upcase-region function. (otherwise disabled to avoid confusing n00bs?)
;   http://stackoverflow.com/questions/10026221/enable-all-disabled-commands-permanently
(put 'upcase-region 'disabled nil)

; https://github.com/nex3/perspective-el/issues/64
(when (not (fboundp 'make-variable-frame-local))
  (defun make-variable-frame-local (variable) variable))

(setq load-path
        (cons "~/.emacs.d/lisp" load-path))


(setq winmachine1 "BOOTCAMP-W7-PC")

(setq debmachine1 "deb1.m.home")


(setq desktop-path '("~/.emacs.d/" "~" "."))



(setq desktop-restore-eager 25) ; restore N buffers immediately, the rest lazily. [otherwise ALL buffers load by default]
(desktop-save-mode 1)

(setq-default fill-column 80)  ; 80 for google style
(setq fill-column 80)  ; 80 for google style

; thanks to: https://stackoverflow.com/a/24857101/10278
(defun untabify-conditionally ()
  (unless (or (derived-mode-p 'makefile-gmake-mode)
              (derived-mode-p 'makefile-mode)
              (derived-mode-p 'go-mode))
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'untabify-conditionally)

(defun dtw ()
        (interactive)
    (delete-trailing-whitespace)
)

(defun fs ()
  (interactive)
  ; runs an immediate full check on the file (before you even edit it)
  (flyspell-buffer)
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

; with some cleanup, this possibly belongs here:
; https://stackoverflow.com/questions/37642626/how-to-clear-the-input-output-buffer-when-when-execute-gud-run-in-emacs
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

(require 'qmake-mode)

(add-to-list 'auto-mode-alist '("\\.pri$" . qmake-mode))

(require 'py-yapf)
(require 'go-mode-autoloads)
(require 'go-dlv)

(require 'longlines) ; until i figure out what has replaced this. to read: http://emacs.stackexchange.com/questions/10798/if-longlines-mode-is-removed-in-new-emacs-how-can-i-soft-wrap-the-line-around-t

(require 'fill-column-indicator) ; To toggle, use the command: fci-mode

(require 'show-wspace) ; ~/.emacs.d/show-wspace.el
(require 'list-register)

(require 'dos)
(require 'markdown-mode)
(require 'coffee-mode)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.pbtxt$" . yaml-mode))

(require 'cc-mode) ; /Applications/Emacs.app/Contents/Resources/lisp/progmodes/cc-mode.elc

(require 'protobuf-mode)
(add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))

(add-hook 'protobuf-mode-hook
          (lambda () (flyspell-prog-mode)))

(defun sqlfmt-hook-innards ()
  (progn
    (setq cmd "/opt/repositories/priv-dots/homebinpath/fsqlf ") ; keep trailing space in cmd
    (setq fullcmd (concat (concat (concat cmd (prin1-to-string buffer-file-name)) "  > 7bff3785ba33.sql ; mv 7bff3785ba33.sql ") (prin1-to-string buffer-file-name)))
    (shell-command fullcmd)
    ;(message "ran command: %s" fullcmd)
    ;(message "mode: %s" major-mode)
    (revert-buffer 'ignore-auto 'noconfirm)))

(defun sqlfmt-i ()
  (interactive)
  (if buffer-file-name
      (progn
        (sqlfmt-hook-innards))))

(defun sqlfmt-hook ()
  (if buffer-file-name
      (progn
        (if (eq major-mode 'sql-mode)
            (sqlfmt-hook-innards)))))

(add-hook 'after-save-hook 'sqlfmt-hook)

(require 'qml-mode) ; in ~/.emacs.d/ ; qml needed to be required after cc-mode
(add-to-list 'auto-mode-alist '("\\.qml$" . qml-mode))

(add-hook 'qml-mode-hook
          (lambda () (flyspell-prog-mode)))
(add-hook 'qml-mode-hook
          (lambda ()   (set-fill-column 80)))
(add-hook 'qml-mode-hook 'fci-mode)

; to force it to get paths from bashrc:
;    (setq cmd "/bin/bash -i /opt/repositories/priv-dots/homebinpath/qmlfmt ") ; keep trailing space in cmd
;    (setq fullcmd (concat (concat cmd (prin1-to-string buffer-file-name)) " >> /Users/developer/this.txt 2>&1"))
(defun qmlfmt-hook-innards ()
  (progn
    (setq cmd "/opt/repositories/priv-dots/homebinpath/qmlfmt ") ; keep trailing space in cmd
    (setq fullcmd (concat (concat cmd (prin1-to-string buffer-file-name)) " > /dev/null 2>&1"))
    (shell-command fullcmd)
    (message "ran command: %s" fullcmd)
    (revert-buffer 'ignore-auto 'noconfirm)))

(defun qmlfmt-i ()
  (interactive)
  (if buffer-file-name
      (progn
        (qmlfmt-hook-innards))))

; using https://github.com/jesperhh/qmlfmt
; with my own instructions as documented here:
;    https://gist.github.com/pestophagous/8efbfcde8539c0af3dcea5f46e2cf46d
(defun qmlfmt-hook ()
  (if buffer-file-name
      (progn
        (if (derived-mode-p 'qml-mode)
            (qmlfmt-hook-innards)))))

(add-hook 'after-save-hook 'qmlfmt-hook)

;(add-to-list 'load-path "/opt/repos/matlab-emacs-src") ; git clone git://git.code.sf.net/p/matlab-emacs/src
;(load-library "matlab-load")

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))


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

; the next line should show a CARET, then a capital X, then o. in a browser and in bash console i only see "o"
(global-set-key (kbd "o") 'revert-no-asking) ; letter "o" for open. re-open file from disk.

(global-set-key (kbd "C-x r v") 'list-register) ; "registers view"

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

(add-hook 'c-mode-common-hook
          (lambda () (flyspell-prog-mode)))

(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ipp?$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.m\\'" . c++-mode))

(require 'find-file) ;; for the "cc-other-file-alist" variable
(nconc (cadr (assoc "\\.h\\'" cc-other-file-alist)) '(".m" ".mm"))
(add-to-list 'cc-other-file-alist '("\\.m\\'" (".h")))
(add-to-list 'cc-other-file-alist '("\\.mm\\'" (".h")))


(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

(require 'clang-format)
;; clang-format Hook function
(defun clang-format-before-save ()
  "Add this to .emacs to clang-format on save
 (add-hook 'before-save-hook 'clang-format-before-save)."

  (interactive)
  (when (or (eq major-mode 'c++-mode) (eq major-mode 'protobuf-mode)) (clang-format-buffer)))

;; Install hook to use clang-format on save
(add-hook 'before-save-hook 'clang-format-before-save)
;; For some sessions, if you want to disable the above line AFTER already
;; launching emacs, then paste the following into *scratch* and run it:
;;    (remove-hook 'before-save-hook 'clang-format-before-save)

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
(add-hook 'python-mode-hook 'py-yapf-enable-on-save)

(defun autopepeight-hook-innards ()
  (progn
    ; (setq cmd "/opt/repositories/client/redacted/redacted/env/bin/autopep8 -i ") ; keep trailing space in cmd
    (setq cmd "autopep8 -i ") ; keep trailing space in cmd
    (setq fullcmd (concat (concat cmd (prin1-to-string buffer-file-name)) " > /dev/null 2>&1"))
    (shell-command fullcmd)
    (message "ran command: %s" fullcmd)
    (revert-buffer 'ignore-auto 'noconfirm)))

(defun autopepeight-hook ()
  (if buffer-file-name
      (progn
        (if (derived-mode-p 'python-mode)
            (autopepeight-hook-innards)))))

(add-hook 'after-save-hook 'autopepeight-hook)

; BAZEL BUILD syntax highlights like python:
(add-to-list 'auto-mode-alist '("\\.bzl$" . python-mode))
(add-to-list 'auto-mode-alist '("BUILD$" . python-mode))
(add-to-list 'auto-mode-alist '("WORKSPACE$" . python-mode))

(add-to-list 'auto-mode-alist '("bazelrc$" . conf-mode))
(add-to-list 'auto-mode-alist '("bazel.rc$" . conf-mode))
(add-to-list 'auto-mode-alist '("Doxyfile$" . conf-mode))

(add-hook 'python-mode-hook
          (lambda () (flyspell-prog-mode)))
(add-hook 'conf-mode-hook
          (lambda () (flyspell-prog-mode)))

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

(defun my-sh-mode-common-hook ()
  ; i went nuts and pasted in anything about tabs that i found.
  ; at some point i should find out if all these symbols even exist or not
  (setq tab-width 2)
  (setq sh-basic-offset 2)
  (setq c-tab-width 2)
  (setq tab-always-indent t)
  (setq c-tab-always-indent t)
  (setq c-basic-offset 2)
  (setq c-indent-level 2)
  (setq indent-tabs-mode nil) ; use spaces only if nil ; at one point i was passing 't'
  (set-variable 'c-indent-offset 2)
  (set-variable 'indent-tabs-mode nil)
) ; end of (defun my-sh-mode-common-hook ()

(add-hook 'sh-mode-hook 'my-sh-mode-common-hook)

(add-hook 'sh-mode-hook
          (lambda () (flyspell-prog-mode)))

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

(add-hook 'go-mode-hook
          (lambda () (flyspell-prog-mode)))

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
    ; DNC DNC DNC DNC
    ;(set-face-attribute 'default nil :font  "DejaVu Sans Mono")
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

;(set-face-attribute 'default nil :font  "Ubuntu Mono 13")

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
(setq mac-command-modifier 'control)

;(setq mac-option-modifier 'meta)


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
         "protobuf/src: warning: directory does not exist."
         "googleapis/googleapis/.: warning: directory does not exist."
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
          (string-prefix-p "SUBCOMMAND" just-a-line) ; for bazel build -s --[no]subcommands [-s]
          (string-prefix-p ">>>>>>>>>" just-a-line) ; for bazel build -s --[no]subcommands [-s]
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

;;  for bazelrc
;;    along with.....
;;             sudo sysctl fs.inotify.max_user_watches=16777215
;;
;; ################################################################################
;; # LOCAL DEVELOPER CHOICES
;; ################################################################################

;; # found these 'startup' things here: https://github.com/tensorflow/models/issues/195
;; startup --batch_cpu_scheduling
;; startup --io_nice_level 3
;; startup --max_idle_secs=0
;; startup --watchfs


;; build -c dbg
;; build --verbose_failures
;; build --jobs 6 --ram_utilization_factor 50  # this line from https://github.com/tensorflow/models/issues/195

;; test -c dbg
;; test --test_output=errors
;; test --verbose_failures


;; build --noforce_pic
;; test --noforce_pic
;; build --dynamic_mode off
;; test --dynamic_mode off
;; #build --linkopt="-static"
;; #test --linkopt="-static"


;; # END LOCAL
;; ###-----------------------------------------------------------------------------



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

(setq mybuild-command "/opt/repos/priv-dots/cdvv/bashies/build1.sh")

(defun sucompile ()
        (interactive)
        (progn
                (setq save-pre-dir default-directory)
                (setq default-directory mybuild-dir)
; Locally toggle the 't' arg as needed. Leave out when not needed, because it interferes with our compile-completion code!
                (compile mybuild-command) ; t) ; the 't' arg after mybuild-command lets compile be INTERACTIVE if (e.g.) it needs sudo password
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

(setq recenter-positions '(top middle bottom))

(defun my-routine-to-execute-upon-compile-completion (buffer string)
  ; we have to check for 'compilation-mode because OTHER EMACS FEATURES use the compilation hooks!
  ; That caught me by surprise! but see here: https://lists.gnu.org/archive/html/help-gnu-emacs/2008-08/msg00158.html
  ; From:       Kevin Rodgers
  ; Subject:    Re: compilation/grep buffer advice
  ; Date:       Thu, 07 Aug 2008 21:19:23 -0600
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

; some shortcuts for TABLE EDITING:
;; (table-insert "3" "3" "15" "1")
;; (table-insert "4" "4" "15" "1")
;; (table-insert-column 1)
;; (table-span-cell 'right)
;; (table-span-cell 'below)

; SEARCH BY WHOLE WORD MATCH:
; (( M-s w )) then the WORD, then C-s, C-s, C-s ... as usual

(menu-bar-mode -1)
(tool-bar-mode -1)

;(setq frame-title-format "%b")

(setq linum-disabled-modes-list '(eshell-mode wl-summary-mode compilation-mode))

(defun linum-on () (unless (or (minibufferp) (member major-mode linum-disabled-modes-list)) (linum-mode 1)))

(defcustom smart-to-ascii '(("\x201C" . "\"")
                            ("\x201D" . "\"")
                            ("\x2018" . "'")
                            ("\x2019" . "'")
                            ;; ellipses:
                            ("\x2026" . "...")
                            ;; en-dash
                            ("\x2013" . "-")
                            ;; em-dash
                            ("\x2014" . "-"))
  ""
  :type '(repeat (cons (string :tag "Smart Character  ")
                       (string :tag "Ascii Replacement"))))

(defun replace-smart-to-ascii (beg end)
  (interactive "r")
  (format-replace-strings smart-to-ascii
                          nil beg end))

(add-to-list 'auto-mode-alist '("\\.lispinteraction$" . lisp-interaction-mode))
(find-file  "~/.emacs.d/lisp/lispscratch.lispinteraction")

; MELPA begin

; if you are still on ubuntu 16 (or anywhere with emacs 24 or below):
;   sudo add-apt-repository ppa:kelleyk/emacs
;   sudo apt-get update
;   sudo apt-get install emacs25

(setq package-user-dir "~/.emacs.d/lisp/elpa") ; https://stackoverflow.com/a/15735931/10278
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
; MELPA end
