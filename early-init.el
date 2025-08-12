;;; early-init.el --- Early initialization for Emacs 27+ -*- lexical-binding: t; -*-
;;; Commentary:
;; This file is loaded before the package system and GUI are initialized.
;; Use this for performance optimizations and early UI tweaks.

;;; Code:

;; Defer garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Prevent unwanted runtime compilation
(setq native-comp-deferred-compilation nil)

;; Disable package.el in favor of our manual setup
(setq package-enable-at-startup nil)

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Resizing the Emacs frame can be expensive
(setq frame-inhibit-implied-resize t)

;; Ignore X resources
(advice-add #'x-apply-session-resources :override #'ignore)

;; Faster to disable these here before they're loaded
(setq site-run-file nil)

;; Set preferred frame size
(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 40))

;; Prevent flash of unstyled content
(setq-default inhibit-redisplay t)
(add-hook 'window-setup-hook
          (lambda ()
            (setq-default inhibit-redisplay nil)
            (redisplay)))

(provide 'early-init)
;;; early-init.el ends here