(require-package 'goto-last-change)
(require-package 'ecb)
(require-package 'yasnippet)
(require-package 'emacs-eclim)
(require-package 'company)
(require-package 'gtags)


;; Goto-the-last-change
(load-file (expand-file-name "~/.emacs.d/goto-last-change.el"))
(require 'goto-last-change)
(global-set-key (kbd "C-x C-_") 'goto-last-change)


;; ECB Setting
(require 'ecb-autoloads)
(custom-set-variables
 '(ecb-source-path (quote ("/home/leo/Program" ("/home/leo/Program/TestProject" "yes"))))
 '(ecb-windows-width 0.25))


;; YASnippet Setting
(require 'yasnippet)




;;; Groovy-mode Setting
(load-file (expand-file-name "~/.emacs.d/plugins/Emacs-Groovy-Mode/groovy-mode.el"))
(load-file (expand-file-name "~/.emacs.d/plugins/Emacs-Groovy-Mode/groovy-electric.el"))
;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;;; make Groovy mode electric by default.
(add-hook 'groovy-mode-hook
          '(lambda ()
             (require 'groovy-electric)
             (groovy-electric-mode)))





;; emacs-eclim setting
(require 'eclim)
(require 'eclimd)
(global-eclim-mode t)

;; Variables
(setq eclim-auto-save t
      ;; To make magit work, need to change to the bash shell.There for use the bash script instead of the bat here.
      eclim-executable "d:/leo/software/eclipse-jee-kepler-SR1-win32-x86_64/eclipse/eclim"
      eclimd-executable "d:/leo/software/eclipse-jee-kepler-SR1-win32-x86_64/eclipse/eclimd"
      eclimd-wait-for-process nil
      eclimd-default-workspace "d:/leo/workspace"
      eclim-use-yasnippet nil
      help-at-pt-display-when-idle t
      help-at-pt-timer-delay 0.1
      )


;; Hook eclim up with auto complete mode
(require 'auto-complete-config)
(ac-config-default)
(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)

(require 'company)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)

;; Displaying compilation error messages in the echo area
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)


;; GTags Setting
(add-to-list 'load-path "~/.emacs.d/plugins/gnu_global_622wb/share/gtags/")

(require 'gtags)
(autoload 'gtags-mode "gtags-mode" "Loading GNU Global")
(add-hook 'java-mode-hook '(lambda ()
                             (setq tab-width 4)
                             (ggtags-mode t)))

(add-hook 'nxml-mode-hook '(lambda ()
                             (setq tab-width 4)))

;; re-open file if it is read-only
;; TODO cannot use this feature in ido-find-file
(defun th-rename-tramp-buffer ()
  (when (file-remote-p (buffer-file-name))
    (rename-buffer
     (format "%s:%s"
             (file-remote-p (buffer-file-name) 'method)
             (buffer-name)))))

(add-hook 'find-file-hook
          'th-rename-tramp-buffer)

(defadvice find-file (around th-find-file activate)
  "Open FILENAME using tramp's sudo method if it's read-only."
  (if (and (not (file-writable-p (ad-get-arg 0)))
           (y-or-n-p (concat "File "
                             (ad-get-arg 0)
                             " is read-only.  Open it as root? ")))
      (sudo-find-file (ad-get-arg 0))
    ad-do-it))

(defun sudo-find-file (file)
  "Opens FILE with root privileges."
  (interactive "F")
  (set-buffer (find-file (concat "/sudo::" file))))

(defun su-edit ()
  "Edit the current buffer file as superuser."
  (interactive)
  (let((window-start (window-start))
       (point (point))
       (pres-reg-beg (if (use-region-p) (region-beginning) nil)))
    (find-alternate-file (format "/sudo::%s" (buffer-file-name)))
    (message (format "The variable is %d." pres-reg-beg))
    (if pres-reg-beg (set-mark pres-reg-beg)) ; same: set-mark-command
    (goto-char point)
    (set-window-start nil window-start) )) ; nil - the selected window

(global-linum-mode 1)


(provide 'init-leo)
