;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; (setq warning-minimum-level :error)

(setq user-full-name "Chen Xianbin"
      user-mail-address "517926804@qq.com"
      epa-file-encrypt-to user-mail-address
      auth-sources '("~/.authinfo.gpg"))

(add-hook! 'emacs-startup-hook (setq default-directory "~/"
                                     org-directory "~/Documents/org"
                                     org-agenda-files (list org-directory)))

(setq x-select-enable-clipboard-manager nil)

;; workspaces
(setq +workspaces-on-switch-project-behavior t)

;; projectile
(after! projectile
  (setq projectile-project-search-path '("~/"))

  (dolist (suffix '(".bak" ".exe"))
    (add-to-list 'projectile-globally-ignored-file-suffixes suffix)))

(if (featurep! :editor file-templates)
    (set-file-template! "/pom\\.xml$" :trigger "__pom.xml" :mode 'nxml-mode))

(after! nxml-mode
  (setq nxml-auto-insert-xml-declaration-flag nil
        nxml-slash-auto-complete-flag t)

  (defadvice! +nxml-electric-slash-a (&optional _)
    :after #'nxml-electric-slash
    (save-excursion (delete-char -1))))
