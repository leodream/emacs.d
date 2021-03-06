(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-generic-program "google-chrome")
 '(column-number-mode t)
 '(display-time-mode t)
 '(ecb-layout-name "left8")
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote ("/home/leo/Program" ("/home/leo/Program/TestProject" "yes"))))
 '(ecb-windows-width 0.2)
 '(font-use-system-font t)
 '(jde-complete-function (quote jde-complete-menu))
 '(jde-debugger (quote ("jdb")))
 '(jde-jdk-registry (quote (("1.6.0_24" . "/usr/lib/jvm/java-1.6.0-openjdk-amd64"))))
 '(jde-resolve-relative-paths-p t)
 '(nxml-heading-element-name-regexp "title\\|head\\|bean\\|artifactId\\|id\\|groupId\\|directory")
 '(nxml-section-element-name-regexp "article\\|\\(sub\\)*section\\|chapter\\|div\\|appendix\\|part\\|preface\\|reference\\|simplesect\\|bibliography\\|bibliodiv\\|glossary\\|glossdiv\\|dependency\\|plugin\\|resource\\|.*epository")
 '(nxml-slash-auto-complete-flag t)
 '(scroll-bar-mode nil)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(truncate-partial-width-windows nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)


;; Windows Management
;; batter window navigation
(windmove-default-keybindings)
    (global-set-key (kbd "C-c h")  'windmove-left)
    (global-set-key (kbd "C-c l") 'windmove-right)
    (global-set-key (kbd "C-c k")    'windmove-up)
    (global-set-key (kbd "C-c j")  'windmove-down)

;; window management
(global-set-key (kbd "C-S-h") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-l") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-j") 'shrink-window)
(global-set-key (kbd "C-S-k") 'enlarge-window)
(winner-mode t)
(global-set-key (kbd "C-c u") 'winner-undo)
(global-set-key (kbd "C-c r") 'winner-redo)

;; dired-jump
(global-set-key (kbd "C-x C-j") 'dired-jump)

;; re-open file if it is read-only
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
      (th-find-file-sudo (ad-get-arg 0))
    ad-do-it))

(defun th-find-file-sudo (file)
  "Opens FILE with root privileges."
  (interactive "F")
  (set-buffer (find-file (concat "/sudo::" file))))

(defvar th-shell-popup-buffer nil)

;; Goto-the-last-change
(load-file (expand-file-name "~/.emacs.d/goto-last-change.el"))
(require 'goto-last-change)
(global-set-key (kbd "C-x C-/") 'goto-last-change)


;; popup a shell clicking F12
(defun th-shell-popup ()
  "Toggle a shell popup buffer with the current file's directory as cwd."
  (interactive)
  (unless (buffer-live-p th-shell-popup-buffer)
    (save-window-excursion (shell "*Popup Shell*"))
    (setq th-shell-popup-buffer (get-buffer "*Popup Shell*")))
  (let ((win (get-buffer-window th-shell-popup-buffer))
	(dir (file-name-directory (or (buffer-file-name)
				            ;; dired
				            dired-directory
					          ;; use HOME
					          "~/"))))
    (if win
	(quit-window nil win)
      (pop-to-buffer th-shell-popup-buffer nil t)
      (comint-send-string nil (concat "cd " dir "\n")))))

(global-set-key (kbd "<f12>") 'th-shell-popup)

;; turn on soft wrapping mode for org mode
(add-hook 'org-mode-hook
  (lambda () (setq truncate-lines nil)))

;; org auto cut line
;;(lambda () (setq truncate-lines nil)))

;; Active indent-mode when using org-mode
(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode t))
          t)


;; 自动添加括号
;; ( setq skeleton-pair-alist nil)
;; (global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "<") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)


;; Set the debug option to enable a backtrace when a
;; problem occurs.
;; 当有问题出现显示错误信息，便于调试
;; (setq debug-on-error t)
;; Update the Emacs load-path to include the path to
;; the JDE and its require packages. This code assumes
;; that you have installed the packages in the emacs/site
;; subdirectory of your home directory.
;; 加载所需的package

(load-file (expand-file-name "~/.emacs.d/smart-compile+.el"))
	   
;;(defalias 'xml-mode 'sgml-xml-mode)
;;(add-to-list 'load-path "~/.emacs.d/plugins/psgml-1.3.2")
;;(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
;;(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

;; auto completion 设置
(add-to-list 'load-path "~/.emacs.d")
(require 'auto-complete-config)
;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;(global-auto-complete-mode 1)

;; weibo setting
(add-to-list 'load-path "~/.emacs.d/plugins/weibo.emacs")
(require 'weibo)

;; yasnippet
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
;;(setq yas-snippet-dirs '("~/.emacs.d/snippets" "~/.emacs.d/plugins/yasnippet/extras/imported"))
(yas-global-mode 1)

;;; turn on syntax highlighting
(global-font-lock-mode 1)


;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(add-to-list 'load-path
	     "~/.emacs.d/plugins/Emacs-Groovy-Mode")

(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;;; make Groovy mode electric by default.
(add-hook 'groovy-mode-hook
          '(lambda ()
             (require 'groovy-electric)
             (groovy-electric-mode)))

;; emacs-eclim
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/eclim/vendor"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/emacs-eclim"))
(require 'eclim)
(setq eclim-auto-save t)
(global-eclim-mode)


;;auto java complete
;; (add-to-list 'load-path "~/.emacs.d/plugins/ajc-java-complete")
;; (require 'ajc-java-complete-config)
;; (add-hook 'java-mode-hook 'ajc-java-complete-mode)
;; (add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)


(setq byte-compile-warnings nil)
 (add-to-list 'load-path (expand-file-name "~/Software/jdee/cedet-1.1/eieio"))
 (add-to-list 'load-path (expand-file-name "~/Software/jdee/cedet-1.1/semantic"))
 (add-to-list 'load-path (expand-file-name "~/Software/jdee/jdee-2.4.0.1/lisp"))
 (add-to-list 'load-path (expand-file-name "~/Software/jdee/cedet-1.1/common"))
 (load-file (expand-file-name "~/Software/jdee/cedet-1.0/common/cedet.el"))
(add-to-list 'load-path (expand-file-name "~/Software/jdee/elib-1.0"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/ecb"))

(require 'cedet)
(require 'semantic-ia)
(require 'ecb)
 
;; Enable EDE (Project Management) features
;;(global-ede-mode 1)
 
(semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)
 
;; Enable SRecode (Template management) minor-mode.
(global-srecode-minor-mode 1)


;; If you want Emacs to defer loading the JDE until you open a
;; Java file, edit the following line
;; 不自动加载jde-mode
(setq defer-loading-jde t)
;; to read:
;;
;;  (setq defer-loading-jde t)
;;
;; 编辑.java文件时加载jde
(if defer-loading-jde
    (progn
      (autoload 'jde-mode "jde" "JDE mode." t)
      (setq auto-mode-alist
       (append
        '(("\\.java\\'" . jde-mode))
        auto-mode-alist)))
  (require 'jde))



;;;; 具体说明可参考源码包下的INSTALL文件，或《A Gentle introduction to Cedet》
;; Enabling Semantic (code-parsing, smart completion) features
;; Select one of the following:
;;(semantic-load-enable-minimum-features)
;;(semantic-load-enable-code-helpers)
;;(semantic-load-enable-gaudy-code-helpers)
(semantic-load-enable-excessive-code-helpers)
;;(semantic-load-enable-semantic-debugging-helpers)
 
;;;; 使函数体能够折叠或展开
;; Enable source code folding
(global-semantic-tag-folding-mode 1)
(global-linum-mode 1) 
;; Key bindings
;(defun my-cedet-hook ()
;  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
;  (local-set-key "C-c C-v C-c" 'smart-compile)
  ;(local-set-key "C-c C-v C-c" 'semantic-ia-complete-symbol-menu)
;  (local-set-key "/C-cd" 'semantic-ia-fast-jump)
;  (local-set-key "/C-cr" 'semantic-symref-symbol)
;  (local-set-key "/C-cR" 'semantic-symref))
;(add-hook 'c-mode-common-hook 'my-cedet-hook)
 
;;;; 当输入"."或">"时，在另一个窗口中列出结构体或类的成员
;(defun my-c-mode-cedet-hook ()
;  (local-set-key "." 'semantic-complete-self-insert)
;  (local-set-key ">" 'semantic-complete-self-insert))
;(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)


(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (with-selected-frame frame
                  (set-fontset-font "fontset-default"
                                    'chinese-gbk "WenQuanYi Micro Hei Mono 12"))))
  (set-fontset-font "fontset-default" 'chinese-gbk "WenQuanYi Micro Hei Mono 12"))


