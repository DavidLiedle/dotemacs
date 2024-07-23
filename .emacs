;;; init.el --- Emacs configuration for DavidCanHelp
;;; Commentary:
;; This is the Emacs configuration file for DavidCanHelp.
;; Email: david.liedle@protonmail.com

;;; Code:

;; Package Management
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Disable signature checking if GPG key is not available
(setq package-check-signature nil)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Appearance and Themes
;;;###autoload
(defun my-text-mode-setup ()
  "Configure settings for text mode (-nw)."
  (load-theme 'wombat t) ;; Black background with lime green text (adjust as needed)
  (set-face-foreground 'default "lime")
  (set-face-background 'default "black")
  (set-face-attribute 'default nil :height 120)) ;; 12pt font

;;;###autoload
(defun my-gui-mode-setup ()
  "Configure settings for GUI mode."
  (load-theme 'wombat t) ;; Black background with lime green text (adjust as needed)
  (set-face-foreground 'default "lime")
  (set-face-background 'default "black")
  (set-face-attribute 'default nil :height 120) ;; 12pt font
  (global-font-lock-mode t)) ;; Enable syntax highlighting

(if (display-graphic-p)
    (my-gui-mode-setup)
  (my-text-mode-setup))

;; Line Numbers
(global-display-line-numbers-mode t)

;; Basic Editing Preferences
(setq-default indent-tabs-mode nil) ;; Use spaces instead of tabs
(setq-default tab-width 4) ;; Set width for tabs
(setq indent-line-function 'insert-tab) ;; Insert tabs for indentation

;; Enable automatic indentation
(electric-indent-mode t)
;; To disable automatic indentation, uncomment the following line
;; (electric-indent-mode -1)

;; Backup and Autosave
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-saves/" t)))
(setq make-backup-files t) ;; Enable backups
(setq auto-save-default t) ;; Enable autosave

;; Keybindings
;; Custom keybindings section (example provided)
;;;###autoload
(defun my-custom-keybindings ()
  "Set custom keybindings."
  ;; (global-set-key (kbd "C-c u") 'undo) ;; Example: bind C-c u to undo
  )
(my-custom-keybindings)

;; Enable y/n answers instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Disable startup screen
(setq inhibit-startup-screen t)
(setq initial-buffer-choice t)
(setq initial-scratch-message nil)

;; Shell Integration
;; ansi-term is built-in, so no need to install
(global-set-key (kbd "C-c t") 'ansi-term)

;; Auto-completion with company-mode
(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

;; Syntax checking with flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Project management with projectile
(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

(provide 'init)
;;; init.el ends here
