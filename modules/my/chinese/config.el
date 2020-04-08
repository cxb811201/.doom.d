;;; my/chinese/config.el -*- lexical-binding: t; -*-

;; rime
(use-package! rime
  :defer t
  :bind
  (:map rime-mode-map
    ("C-`" . #'rime-send-keybinding))
  :custom
  (default-input-method "rime")
  (rime-librime-root (if IS-MAC (expand-file-name "librime/dist/" doom-etc-dir)))
  (rime-user-data-dir (expand-file-name "rime/" doom-etc-dir))
  (rime-show-candidate (if (featurep! +childframe) 'posframe))
  (rime-inline-ascii-trigger 'shift-l)
  (rime-disable-predicates '(rime-predicate-after-alphabet-char-p
                             rime-predicate-prog-in-code-p))
  (rime-inline-predicates '(rime-predicate-current-uppercase-letter-p))
  :hook
  ('after-init . (lambda ()
                   (when (fboundp 'rime-lib-sync-user-data)
                     (ignore-errors (rime-sync)))))
  ('kill-emacs . (lambda ()
                   (when (fboundp 'rime-lib-sync-user-data)
                     (ignore-errors (rime-sync)))))
  ('scala-mode . (lambda ()
                   (add-hook! 'post-command-hook :local
                     (if (fboundp 'rime--redisplay)
                         (rime--redisplay)))))
  :config
  (after! doom-modeline
    (set-face-attribute 'rime-indicator-face nil
                        :foreground 'unspecified
                        :inherit 'doom-modeline-buffer-major-mode)
    (set-face-attribute 'rime-indicator-dim-face nil
                        :foreground 'unspecified
                        :inherit 'doom-modeline-buffer-minor-mode)

    (doom-modeline-def-segment input-method
      "Define the current input method properties."
      (propertize (cond (current-input-method
                         (concat (doom-modeline-spc)
                                 current-input-method-title
                                 (doom-modeline-spc)))
                        ((and (bound-and-true-p evil-local-mode)
                              (bound-and-true-p evil-input-method))
                         (concat
                          (doom-modeline-spc)
                          (nth 3 (assoc default-input-method input-method-alist))
                          (doom-modeline-spc)))
                        (t ""))
                  'face (if (doom-modeline--active)
                            (or (get-text-property 0 'face (rime-lighter))
                                'doom-modeline-buffer-major-mode)
                          'mode-line-inactive)
                  'help-echo (concat
                              "Current input method: "
                              current-input-method
                              "\n\
mouse-2: Disable input method\n\
mouse-3: Describe current input method")
                  'mouse-face 'mode-line-highlight
                  'local-map mode-line-input-method-map))))

;;; Hacks
(defadvice! +chinese--org-html-paragraph-a (args)
  "Join consecutive Chinese lines into a single long line without unwanted space
when exporting org-mode to html."
  :filter-args #'org-html-paragraph
  (++chinese--org-paragraph args))

(defadvice! +chinese--org-hugo-paragraph-a (args)
  "Join consecutive Chinese lines into a single long line without unwanted space
when exporting org-mode to html."
  :filter-args #'org-hugo-paragraph
  (++chinese--org-paragraph args))

(defun ++chinese--org-paragraph (args)
  (cl-destructuring-bind (paragraph contents info) args
    (let* ((fix-regexp "[[:multibyte:]]")
           (origin-contents
            (replace-regexp-in-string
             "<[Bb][Rr] */>"
             ""
             contents))
           (fixed-contents
            (replace-regexp-in-string
             (concat "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)")
             "\\1\\2"
             origin-contents)))
      (list paragraph fixed-contents info))))
