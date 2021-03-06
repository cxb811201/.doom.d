;;; my/debugger/config.el -*- lexical-binding: t; -*-

;; dap-mode
(after! dap-mode
  (add-hook! '(dap-session-created-hook dap-stopped-hook)
    (defun show-dap-hydra (&rest _)
      "Show dap hydra"
      (dap-hydra)))

  (add-hook! 'dap-terminated-hook
    (defun hide-dap-hydra (&rest _)
      "Hide dap hydra"
      (dap-hydra/nil))))
