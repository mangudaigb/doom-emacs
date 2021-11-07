;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jibitesh Prasad"
      user-mail-address "jibitesh.prasad@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;; (setq doom-font (font-spec :family "MesloLGS NF" :size 12))
(setq doom-font (font-spec :family "MesloLGS NF" :size 12)
;;      doom-variable-pitch-font (font-spec :family "SourceCodePro+Powerline+Awesome Regular" :size 14))
)
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
(setq lexical-binding t)
(add-to-list 'default-frame-alist '(height . 240))
(add-to-list 'default-frame-alist '(width . 180))
;; (setq-default custom-file (expand-file-name "custom.el" doom-private-dir))
;; (when (file-exists-p custom-file)
  ;; (load custom-file))
(setq doom-fallback-buffer-name "ॐ"
      +doom-dashboard-name "ॐ")
(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?  buffer-file-name))
           "%b"))
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ॐ %s" "  ॐ  %s") project-name))))))

(add-hook! 'after-save-hook
           #'executable-make-buffer-file-executable-if-script-p)
(add-hook! 'dired-after-readin-hook
           #'+dired-enable-git-info-h )
; (package! dotenv-mode)
; (use-package! dotenv-mode
;   :mode ("\\.env\\.?.*\\'" . dotenv-mode))
(map! :leader
      :desc "Navigate/Hydra" :m "w N" #'+hydra/window-nav/body
      :desc "Text-Zoom/Hydra" :m "w f" #'hydra/text-zoom/body)

(use-package! dap-mode
  :defer
  :custom
  (dap-auto-configure-mode t)
  :config
  ;;; dap for C++
  (require 'dap-lldb)
  (setq dap-lldb-debug-program '("/usr/bin/lldb"))
  (setq dap-lldb-debugged-program-function (lambda () (read-file-name "Select file to debug.")))
  ;;; Default debug template for C++
  (dap-register-debug-template
   "C++ LDB dap"
   (list :type "lldb"
         :cwd nil
         :args nil
         :request "launch"
         :program nil))
  (defun dap-debug-create-or-edit-json-template ()
    (interactive)
    (let ((filename (concat (lsp-workspace-root) "/launch.json"))
          (default "~/.emacs.d/default-C-launch.json"))
      (unless (file-exists-p filename)
        (copy-file default filename))
      (find-file-existing filename))))

(use-package! dap-mode
  :config
  (require 'dap-node)
  (dap-node-setup)
  (general-define-key
   :keymaps 'lsp-mode-map
   :prefix lsp-keymap-prefix
   "d" '(dap-hydra t :wk "debugger")))
