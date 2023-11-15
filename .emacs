;; Old setup from .emacs.d

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'use-package)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" default))
 '(package-selected-packages
   '(yasnippet alchemist go-autocomplete gnugo gruber-darker-theme smex neotree lsp-ui flycheck company-go)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Настройка на flycheck за стартиране автоматично с go-mode
(add-hook 'go-mode-hook 'flycheck-mode)

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0)) ; Колкото по-ниско е това забавяне, толкова по-бързо ще се появи автодопълването


;; Автоматично форматиране на кода при запазване на файла
(add-hook 'before-save-hook 'gofmt-before-save)

;; here

(setenv "PATH" (concat (getenv "PATH") ":" (expand-file-name "~/go/bin")))
(setq exec-path (append exec-path (list (expand-file-name "~/go/bin"))))

(require 'lsp-mode)

(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Настройка на lsp-ui, което предоставя интерфейс към lsp-mode
(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(lsp-register-custom-settings
 '(("gopls.completeUnimported" t t)
   ("gopls.staticcheck" t t)))

;; /here

;; Опционално: Настройка на допълнителни опции за lsp-ui
(setq lsp-ui-doc-enable t
      lsp-ui-doc-use-webkit nil
      lsp-ui-doc-delay 0.5
      lsp-ui-doc-include-signature t
      lsp-ui-doc-position 'at-point
      lsp-ui-sideline-enable nil
      lsp-ui-sideline-show-hover t
      lsp-ui-sideline-show-diagnostics t
      lsp-ui-sideline-show-code-actions t)

;; Опционално: Настройка на ключови комбинации за lsp-ui
(define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
(define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)

(global-display-line-numbers-mode)

;; custom functions

(defun duplicate-line()
  "Duplicate the current line and move the cursor to the duplicate line."
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
	
(global-set-key (kbd "C-d") 'duplicate-line)

;; fixing gocode error докато пиша код - още не работи
(let ((gopath (shell-command-to-string "fish -c 'echo $GOPATH'")))
  (setenv "PATH" (concat gopath "/bin:" (getenv "PATH")))
  (setq exec-path (append (split-string gopath "/bin") exec-path)))

(require 'neotree)
(global-set-key (kbd "C-b") 'neotree-toggle)

(defun increase-window-height ()
  "Increase current window height."
  (interactive)
  (enlarge-window 5))

(defun decrease-window-height ()
  "Decrease current window height."
  (interactive)
  (enlarge-window -5))

(global-set-key (kbd "M-S-<up>") 'increase-window-height)
(global-set-key (kbd "M-S-<down>") 'decrease-window-height)

(defun increase-window-width ()
  "Increase current window width."
  (interactive)
  (enlarge-window-horizontally 5))

(defun decrease-window-width ()
  "Decrease current window width."
  (interactive)
  (shrink-window-horizontally 5))

(global-set-key (kbd "M-S-<right>") 'increase-window-width)
(global-set-key (kbd "M-S-<left>") 'decrease-window-width)

;; Смяна на прозорец
(global-set-key [kbd "C-tab"] 'other-window)


;;;;;;;;;;;;;;;;;;;
;;   New setup   ;;
;;;;;;;;;;;;;;;;;;;

(setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 150)

(ido-mode 1)

;; Smex setup

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(setq lsp-go-analyses '((shadow . t)
                        (simplifycompositelit . :json-false)))


(global-set-key (kbd "C-`") 'other-window)


(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

(defun my-shell-command (command)
  "Execute a shell command and display the output in a new window below."
  (interactive "sShell command: ")
  (let ((output-buffer (generate-new-buffer "*Shell Command Output*")))
    (split-window-below)
    (other-window 1)
    (switch-to-buffer output-buffer)
    (async-shell-command command output-buffer)
    ;; Намалява височината на новия прозорец с 10 реда
    (shrink-window 30)
    ))

(global-set-key (kbd "C-`") 'my-shell-command)

;; (defun my-shell-command (command)
;;   "Execute a shell command and display the output in a new window below."
;;   (interactive "sShell command: ")
;;   (let ((output-buffer (generate-new-buffer "*Shell Command Output*")))
;;     (split-window-below)
;;     (other-window 1)
;;     (switch-to-buffer output-buffer)
;;     (async-shell-command command output-buffer)
;;     ;; Не е нужно да се връщате обратно към оригиналния прозорец
;;     ))


(defun my-go-mode-hook ()
  ;; Set the display tab width
  (setq-local tab-width 2))

(add-hook 'go-mode-hook 'my-go-mode-hook)

(global-set-key (kbd "C-f") 'bookmark-bmenu-list)

(global-set-key (kbd "M-[") 'split-window-vertically)
(global-set-key (kbd "M-]") 'split-window-horizontally)

(global-set-key [C-tab] 'other-window)

(defun close-window-and-kill-this-buffer ()
  "Close the current window and kill the buffer in it."
  (interactive)
  (kill-buffer)
  (delete-window))

(global-set-key (kbd "C-.") 'close-window-and-kill-this-buffer)

(electric-pair-mode 1)

(add-hook 'c-mode-hook
          (lambda ()
            (electric-pair-mode 1)))

(global-set-key (kbd "C-S-b") 'list-buffers)

(defun my-find-file-create-directories (filename)
  "Create parent directory if not exists while visiting a new file."
  (interactive "FFind file: ")
  (let ((parent-directory (file-name-directory filename)))
    (unless (file-exists-p parent-directory)
      (make-directory parent-directory t)))
  (find-file filename))

(global-set-key (kbd "C-x C-f") 'my-find-file-create-directories)
(show-paren-mode 1)


;; Elixir setup

(add-hook 'elixir-mode-hook 'flycheck-mode)

(add-hook 'elixir-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (concat "mix compile " buffer-file-name))))

(add-hook 'elixir-mode-hook 'flycheck-mode)
(add-hook 'elixir-mode-hook 'company-mode)
(add-hook 'elixir-mode-hook
          (lambda ()
            ;; Ваши допълнителни настройки тук
          ))


(use-package elixir-mode
  :ensure t)

(use-package alchemist
  :ensure t
  :after elixir-mode)

;; Templates via yasnippet

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;; Delete paragraph
(defun mark-and-delete-paragraph ()
  "Маркира и изтрива целия параграф, в който се намира курсорът."
  (interactive)
  (mark-paragraph)   ; Маркира целия параграф
  (kill-region (region-beginning) (region-end))) ; Изтрива маркирания текст

(global-set-key (kbd "C-<") 'mark-and-delete-paragraph)


;; Delete func
(defun mark-and-delete-defun ()
  "Маркира и изтрива цялата функция (defun), в която се намира курсорът."
  (interactive)
  (mark-defun)   ; Маркира цялата функция
  (kill-region (region-beginning) (region-end))) ; Изтрива маркирания текст

(global-set-key (kbd "C-a") 'mark-and-delete-defun)

;; Pop to mark command
(global-set-key (kbd "C-<escape>") 'pop-to-mark-command)

;; Global Pop to mark command
(global-set-key (kbd "C-S-<escape>") 'pop-global-mark)

(global-set-key (kbd "M-f") 'ibuffer)
