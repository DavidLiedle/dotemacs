;;; init.el --- Modern Emacs configuration for DavidCanHelp -*- lexical-binding: t; -*-
;;; Commentary:
;; A modern Emacs configuration with improved performance and features.
;; Email: david.liedle@protonmail.com
;; Last updated: 2025

;;; Code:

;; Performance optimizations
(setq gc-cons-threshold (* 100 1024 1024))  ; 100MB GC threshold during init
(setq read-process-output-max (* 1024 1024)) ; 1MB
(setq package-enable-at-startup nil)

;; Package Management - Modern setup with straight.el or improved package.el
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("melpa-stable" . "https://stable.melpa.org/packages/")
                        ("gnu" . "https://elpa.gnu.org/packages/")
                        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; Prioritize stable packages when available
(setq package-archive-priorities '(("melpa-stable" . 10)
                                  ("gnu" . 5)
                                  ("nongnu" . 5)
                                  ("melpa" . 0)))

(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-always-defer t
      use-package-verbose t)

;; Keep ~/.emacs.d clean
(use-package no-littering
  :demand t
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; Modern UI improvements
(use-package emacs
  :ensure nil
  :demand t
  :config
  ;; Clean UI
  (setq inhibit-startup-screen t
        initial-scratch-message nil
        ring-bell-function 'ignore)
  
  ;; Better defaults
  (setq-default indent-tabs-mode nil
                tab-width 4
                fill-column 80
                truncate-lines t)
  
  ;; Enable useful modes
  (global-auto-revert-mode 1)
  (electric-pair-mode 1)
  (show-paren-mode 1)
  (column-number-mode 1)
  (save-place-mode 1)
  (savehist-mode 1)
  (recentf-mode 1)
  
  ;; Line numbers (use display-line-numbers-mode for better performance)
  (when (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode t)
    (setq display-line-numbers-type 'relative))
  
  ;; Mouse support in terminal
  (xterm-mouse-mode 1)
  
  ;; Better scrolling
  (setq scroll-margin 0
        scroll-conservatively 100000
        scroll-preserve-screen-position 1
        mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed nil)
  
  ;; y/n instead of yes/no
  (fset 'yes-or-no-p 'y-or-n-p))

;; Theme configuration with automatic dark/light mode
(use-package doom-themes
  :demand t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; Modern modeline
(use-package doom-modeline
  :demand t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 3
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-buffer-file-name-style 'truncate-upto-project))

;; Icons support
(use-package all-the-icons
  :if (display-graphic-p))

;; Which-key for discovering keybindings
(use-package which-key
  :demand t
  :diminish
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;; Vertico for modern minibuffer completion
(use-package vertico
  :demand t
  :init
  (vertico-mode)
  :config
  (setq vertico-cycle t))

;; Orderless for flexible matching
(use-package orderless
  :demand t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion)))))

;; Marginalia for rich annotations
(use-package marginalia
  :demand t
  :init
  (marginalia-mode))

;; Consult for enhanced search and navigation
(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x r b" . consult-bookmark)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ("M-s r" . consult-ripgrep)
         ("M-s f" . consult-find)))

;; Embark for contextual actions
(use-package embark
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim)
         ("C-h B" . embark-bindings))
  :config
  (setq embark-prompter 'embark-keymap-prompter))

;; Company for auto-completion
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 2
        company-idle-delay 0.2
        company-selection-wrap-around t
        company-tooltip-align-annotations t))

;; LSP support for modern IDE features
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((prog-mode . lsp-deferred))
  :config
  (setq lsp-keymap-prefix "C-c l"
        lsp-idle-delay 0.5
        lsp-enable-snippet t
        lsp-enable-symbol-highlighting t
        lsp-headerline-breadcrumb-enable t))

(use-package lsp-ui
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t))

;; Treemacs for file explorer
(use-package treemacs
  :bind (("M-0" . treemacs-select-window)
         ("C-x t 1" . treemacs-delete-other-windows)
         ("C-x t t" . treemacs)
         ("C-x t B" . treemacs-bookmark)
         ("C-x t C-t" . treemacs-find-file)
         ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after (treemacs projectile))

;; Flycheck for syntax checking
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

;; Projectile for project management
(use-package projectile
  :demand t
  :init (projectile-mode +1)
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (setq projectile-completion-system 'default
        projectile-enable-caching t))

;; Magit for Git integration
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch)))

;; Multiple cursors
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; Expand region
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; Rainbow delimiters for better code readability
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Highlight TODO keywords
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
        '(("TODO" . "#FF0000")
          ("FIXME" . "#FF0000")
          ("DEBUG" . "#A020F0")
          ("NOTE" . "#FF9900"))))

;; Terminal emulation
(use-package vterm
  :commands vterm
  :bind ("C-c t" . vterm)
  :config
  (setq vterm-max-scrollback 10000))

;; Org mode enhancements
(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (setq org-directory "~/org"
        org-default-notes-file (concat org-directory "/notes.org")
        org-log-done 'time
        org-src-fontify-natively t
        org-src-tab-acts-natively t))

;; Programming language specific configurations

;; Python
(use-package python-mode
  :mode "\\.py\\'"
  :hook (python-mode . lsp-deferred))

;; JavaScript/TypeScript
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred))

(use-package web-mode
  :mode (("\\.jsx?\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.html\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

;; Markdown
(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; YAML
(use-package yaml-mode
  :mode "\\.ya?ml\\'")

;; Docker
(use-package dockerfile-mode
  :mode "Dockerfile\\'")

;; Custom functions
(defun my/reload-config ()
  "Reload the Emacs configuration."
  (interactive)
  (load-file user-init-file))

;; Custom keybindings
(global-set-key (kbd "C-c r") 'my/reload-config)
(global-set-key (kbd "C-c f") 'consult-find)
(global-set-key (kbd "C-c g") 'consult-ripgrep)

;; Restore GC threshold after init
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))))

(provide 'init)
;;; init.el ends here