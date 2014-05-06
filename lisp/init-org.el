(when (< emacs-major-version 24)
  (require-package 'org))
(require-package 'org-fstree)
(when *is-a-mac*
  (require-package 'org-mac-link)
  (require-package 'org-mac-iCal))


(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

(setq org-agenda-files (quote ("~/Dropbox/notes/TODOList.org")))
(setq org-directory "/home/leo/Dropbox/notes")

;; Various preferences
(setq org-log-done t
      org-completion-use-ido t
      org-edit-timestamp-down-means-later t
      org-agenda-start-on-weekday nil
      org-agenda-span 14
      org-agenda-include-diary t
      org-agenda-window-setup 'current-window
      org-fast-tag-selection-single-key 'expert
      org-export-kill-product-buffer-when-displayed t
      org-tags-column 80
      org-agenda-tags-column -100)


; Refile targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5))))
; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))
; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)


(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "TOBREAKDOWN(o)" "READY(r)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "BEGINED(b!)" "PROJECT(p)" "SOMEDAY(s)" "|" "CANCELLED(c@/!)"))))


;; Change TODO to DONE automatically after all subtask are done.
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "PROJECT"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(setq org-tag-persistent-alist '((:startgroup . nil)
                      ("acg" . ?A)
                      (:grouptags . nil)
                      ("animate" . ?a)
                      ("comics" . ?C)
                      ("game" . nil)
                      ("music" . ?m)
                      (:endgroup . nil)

                      (:startgroup . nil)
                      ("learn" . ?l)
                      ("work" . ?w)
                      ("life" . ?f)
                      (:endgroup . nil)

                      (:startgroup . nil)
                      ("L_term" . nil)
                      ("S_term" . nil)
                      (:endgroup . nil)

                      ("coding" . ?c)
                      ("shell" . ?s)
                      ("emacs" . ?e)
                      ("linux" . ?L)
                      ("git" . ?g)
                      ("reading" . ?r)

                      (:newline . nil)

                      ("@offic" . ?o)
                      ("@home" . ?h)
                      ("@pc" . ?P)

                      (:newline . nil)

                      ("#MIT#" . ?M)
                      ("#TOBE#" . ?T)
                      ("#URGENT#" . ?U)

                      ))

(defun sacha/org-agenda-skip-scheduled ()
  (org-agenda-skip-entry-if 'scheduled 'deadline 'regexp "\n]+>"))

(defvar sacha/org-agenda-limit-items nil "Number of items to show in agenda to-do views; nil if unlimited.")

(defvar sacha/org-agenda-contexts
  '((tags-todo "+@learn")
    (tags-todo "+@work")
    (tags-todo "+@reading")
    (tags-todo "+@hacking")
    (tags-todo "+@computer")
    (tags-todo "+@home"))
  "Usual list of contexts.")

(setq org-agenda-custom-commands
      '(
        ("u" "Timeline for today and tasks that under going"
         ((agenda "" )
          (todo "PROJECT")
          (todo "BEGINED")
          (todo "READY")
          (todo "WAITING")
          (todo "TOBREAKDOWN")
          (todo "SOMEDAY")
          (todo "TODO"))
         ((org-agenda-ndays 1)
          (org-agenda-show-log t)
          (org-agenda-clockreport-mode t)
          (org-agenda-log-mode-items '(clock closed))))

        ("w" "Weekly Review"
         ((agenda ""
                  ((org-agenda-ndays 7)          ;; review upcoming deadlines and appointments
                   (org-agenda-show-log t)
;;                   (org-agenda-start-on-weekday 1) ;; agenda start with monday
                   (org-agenda-log-mode-items '(clock closed))
                   (org-agenda-clockreport-mode t)
                   (org-agenda-repeating-timestamp-show-all nil)));; ensures that repeating events appear only once

          (todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
          (tags-todo "-SCHEDULED={.+}/+BEGINED")
          (tags-todo "-SCHEDULED={.+}/+READY")
          (tags-todo "-SCHEDULED={.+}/+WAITING")
          (tags-todo "-SCHEDULED={.+}/+TOBREAKDOWN")
          (tags-todo "-SCHEDULED={.+}/+SOMEDAY")
          (tags-todo "-SCHEDULED={.+}/+TODO")))

        ("x" "Items that under going" todo "READY|BEGINED")

        ("P" "By priority"
         ((tags-todo "+PRIORITY=\"A\"")
          (tags-todo "+PRIORITY=\"B\"")
          (tags-todo "+PRIORITY=\"\"")
          (tags-todo "+PRIORITY=\"C\""))
         ((org-agenda-prefix-format "%-10c %-10T %e ")
          (org-agenda-sorting-strategy '(priority-down tag-up category-keep effort-down))))

        ("g" . "Go to specific category")
        ("ge" "Entertainment" tags-todo "CATEGORY=\"Play\"")
        ("gw" "Work" tags-todo "CATEGORY=\"Work\"")
        ("gl" "Learn" tags-todo "CATEGORY=\"Learn\"")
        ("gL" "Life" tags-todo "CATEGORY=\"Life\"")
        ("gp" "Practice" tags-todo "CATEGORY=\"Practice\"")

        ("n" "Agenda and all TODO's"
         ((agenda ""
                  ((org-agenda-ndays 7)
                   (org-agenda-show-log t)
                   ))
          (tags-todo "/-TOBREAKDOWN-SOMEDAY")))

        ))


;; Strike through headlines for DONE tasks in Org
;; http://sachachua.com/blog/2012/12/emacs-strike-through-headlines-for-done-tasks-in-org/
(setq org-fontify-done-headline t)
(custom-set-faces
 '(org-done ((t (:foreground "PaleGreen"
                 :weight normal
                 :strike-through t))))
 '(org-headline-done
            ((((class color) (min-colors 16) (background dark))
               (:foreground "LightSalmon" :strike-through t)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org clock
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persistence-insinuate t)
(setq org-clock-persist t)
(setq org-clock-in-resume t)

(setq org-clock-idle-time 10)

;; Change task state to BEGINED when clocking in
(setq org-clock-in-switch-to-state "BEGINED")
;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(after-load 'org-clock
  (define-key org-clock-mode-line-map [header-line mouse-2] 'org-clock-goto)
  (define-key org-clock-mode-line-map [header-line mouse-1] 'org-clock-menu))


;; ;; Show iCal calendars in the org agenda
;; (when (and *is-a-mac* (require 'org-mac-iCal nil t))
;;   (setq org-agenda-include-diary t
;;         org-agenda-custom-commands
;;         '(("I" "Import diary from iCal" agenda ""
;;            ((org-agenda-mode-hook #'org-mac-iCal)))))

;;   (add-hook 'org-agenda-cleanup-fancy-diary-hook
;;             (lambda ()
;;               (goto-char (point-min))
;;               (save-excursion
;;                 (while (re-search-forward "^[a-z]" nil t)
;;                   (goto-char (match-beginning 0))
;;                   (insert "0:00-24:00 ")))
;;               (while (re-search-forward "^ [a-z]" nil t)
;;                 (goto-char (match-beginning 0))
;;                 (save-excursion
;;                   (re-search-backward "^[0-9]+:[0-9]+-[0-9]+:[0-9]+ " nil t))
;;                 (insert (match-string 0))))))


(after-load 'org
  (define-key org-mode-map (kbd "C-M-<up>") 'org-up-element)
  (when *is-a-mac*
    (define-key org-mode-map (kbd "M-h") nil))
  (define-key org-mode-map (kbd "C-M-<up>") 'org-up-element)
  (when *is-a-mac*
    (autoload 'omlg-grab-link "org-mac-link")
    (define-key org-mode-map (kbd "C-c g") 'omlg-grab-link)))


;; Add function to directly create src-block.
(defun org-insert-src-block (src-code-type)
  "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
  (interactive
   (let ((src-code-types
          '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
            "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
            "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
            "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
            "scheme" "sqlite")))
     (list (ido-completing-read "Source code type: " src-code-types))))
  (progn
    (newline-and-indent)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline-and-indent)
    (insert "#+END_SRC\n")
    (previous-line 2)
    (org-edit-src-code)))


(add-hook 'org-mode-hook '(lambda ()
                            ;; turn on flyspell-mode by default
                            (flyspell-mode 1)
                            ;; C-TAB for expanding
                            ;; (local-set-key (kbd "C-<tab>")
                            ;;                'yas/expand-from-trigger-key)
                            ;; keybinding for editing source code blocks
                            (local-set-key (kbd "C-c s e")
                                           'org-edit-src-code)
                            ;; keybinding for inserting code blocks
                            (local-set-key (kbd "C-c s i")
                                           'org-insert-src-block)
                            ;; turn on indent mode by default
                            (org-indent-mode t)
                            ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mobile Org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-enforce-todo-dependencies t)
(setq org-mobile-directory "~/Dropbox/mobileorg")
(setq org-mobile-inbox-for-pull "~/Dropbox/mobileorg/from-mobil.org")


;; push and pull everytime start and quit emacs
;; causing desktop not save
;;(add-hook 'after-init-hook 'org-mobile-pull)
;;(add-hook 'kill-emacs-hook 'org-mobile-push)


;; mobile sync
(defvar org-mobile-sync-timer nil)
;; sync if emacs has entered idle state for 10 mins
(defvar org-mobile-sync-idle-secs (* 60 10))
(defun org-mobile-sync ()
  (interactive)
  (org-mobile-pull)
  (org-mobile-push))
(defun org-mobile-sync-enable ()
  "enable mobile org idle sync"
  (interactive)
  (setq org-mobile-sync-timer
        (run-with-idle-timer org-mobile-sync-idle-secs t
                             'org-mobile-sync)));
(defun org-mobile-sync-disable ()
  "disable mobile org idle sync"
  (interactive)
  (cancel-timer org-mobile-sync-timer))
(org-mobile-sync-enable)


(require 'org-depend)

(provide 'init-org)
