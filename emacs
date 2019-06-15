(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (use-package restclient expand-region ember-mode web-mode yaml-mode terraform-mode less-css-mode groovy-mode markdown-mode))))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

(use-package dracula-theme
  :defer t
  :init
  (load-theme 'dracula t))

(use-package projectile
  :defer t
  :init
  ;; Projectile should be loaded automatically
  (projectile-global-mode)

  ;; Need an easier way to find file using Projectile, if available,
  ;; or using the standard file-file otherwise.
  ;; - https://emacs.stackexchange.com/a/12651/23627
  (defun find-file-with-projectile-or-fallback ()
    (interactive)
    (call-interactively
     (if (projectile-project-p)
         #'projectile-find-file
       #'find-file)))

  ;; Same thing but for buffers.
  (defun switch-to-buffer-with-projectile-or-fallback ()
    (interactive)
    (call-interactively
     (if (projectile-project-p)
         #'projectile-switch-to-buffer
       #'switch-to-buffer)))

  :bind
  ;; C-t is bound to transpose-chars by default, which I'll never use.
  ;; Let's use it to find files instead.
  ("C-t" . find-file-with-projectile-or-fallback)

  ;; C-l is bound to recenter-to-bottom by default. I would like to use it
  ;; to change buffers.
  ("C-l" . switch-to-buffer-with-projectile-or-fallback)

  :config
  (setq projectile-completion-system 'ivy)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package counsel
  :defer t
  :init
  (ivy-mode t)
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "))

(use-package ivy-posframe
  :defer t
  :init
  (setq ivy-display-function #'ivy-posframe-display-at-frame-center)
  (ivy-posframe-enable))

(use-package magit
  :defer t)

(use-package elpy
  :defer t
  :bind ("<f5>" . recompile)
  :init
  (advice-add 'python-mode :before 'elpy-enable))

;; General
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq explicit-shell-file-name "/bin/zsh")
(delete-selection-mode 1)

(setq-default truncate-lines 1)
(setq-default show-trailing-whitespace t)

(setq show-paren-delay 0)
(show-paren-mode 1)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            ;; short circuit js mode and just do everything in jsx-mode
            (if (equal web-mode-content-type "javascript")
                (web-mode-set-content-type "jsx")
              (message "now set to: %s" web-mode-content-type))))


(defun my-web-mode-hook ()
  "Hooks for Web mode"
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-indent-style 2)
  )
(add-hook 'web-mode-hook 'my-web-mode-hook)

(defun toggle-shortcuts ()
  "Toggle a window with Emacs shortcuts I'm trying to memorize"
  (interactive)
  (if w
      (progn
        (delete-window w)
        (setq w nil))
    (progn
      (setq w (split-window-below -10))
      (with-selected-window w
        (find-file "~/.emacs.shortcuts.md")))
    ))
(setq w nil)
(global-set-key (kbd "<f12>") 'toggle-shortcuts)

(global-set-key (kbd "C-=") 'er/expand-region)

(global-prettify-symbols-mode)

;; JS
(setq js-indent-level 2)

;; EmberJS
(setq ember-command "~/.node_modules/bin/ember")

;; Python
