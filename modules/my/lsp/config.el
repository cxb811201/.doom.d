;;; my/lsp/config.el -*- lexical-binding: t; -*-

;; lsp
(after! lsp-mode
  (setq lsp-enable-snippet nil
        lsp-enable-folding nil
        lsp-enable-links nil
        lsp-enable-symbol-highlighting nil
        lsp-file-watch-threshold 5000
        lsp-eldoc-enable-hover nil)

  ;; don't scan 3rd party javascript libraries
  (push "[/\\\\][^/\\\\]*\\.\\(json\\|html\\|jade\\)$" lsp-file-watch-ignored) ;; json

  ;; kotlin
  (setq lsp-clients-kotlin-server-executable (concat doom-etc-dir "kotlin/server/bin/kotlin-language-server")
        lsp-kotlin-debug-adapter-path (concat doom-etc-dir "kotlin/adapter/bin/kotlin-debug-adapter")))

;; lsp-treemacs
(use-package! lsp-treemacs
  :when (featurep! :tools lsp)
  :config
  (lsp-metals-treeview-enable t)
  (setq lsp-metals-treeview-show-when-views-received nil))
