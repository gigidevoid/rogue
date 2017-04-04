;;; packages.el --- rogue Layer packages File for Spacemacs

(setq rogue-packages
      '(all-the-icons
        all-the-icons-dired
        bm
        browse-at-remote
        cricbuzz
        enlive
        flycheck-mypy
        graphviz-dot-mode
        hackernews
        helm-bm
        helm-org-rifle
        (kde :location (recipe
                        :fetcher github
                        :repo "lepisma/kde.el"))
        magithub
        molokai-theme
        multiple-cursors
        (ob-async :location (recipe
                             :fetcher github
                             :repo "astahlman/ob-async"))
        (ob-q :location (recipe
                         :fetcher github
                         :repo "lepisma/ob-q.el"))
        org-journal
        pretty-mode
        (read-lyrics :location (recipe
                                :fetcher github
                                :repo "lepisma/read-lyrics.el"))
        snakemake-mode
        solarized-theme
        (spaceline-all-the-icons :location local)
        swiper
        sx
        tide
        tldr
        vlf
        vue-mode
        wolfram
        writegood-mode
        writeroom-mode
        wttrin))

;; Initialize packages

(defun rogue/init-all-the-icons ()
  (use-package all-the-icons))

(defun rogue/init-all-the-icons-dired ()
  (use-package all-the-icons-dired
    :init (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)))

(defun rogue/init-bm ()
  (use-package bm
    :ensure t
    :demand t
    :init
    ;; restore on load (even before you require bm)
    (setq bm-restore-repository-on-load t)
    :config
    ;; Allow cross-buffer 'next'
    (setq bm-cycle-all-buffers t)
    ;; where to store persistant files
    (setq bm-repository-file "~/.emacs.d/.cache/bm-repository")
    ;; save bookmarks
    (setq-default bm-buffer-persistence t)
    ;; Loading the repository from file when on start up.
    (add-hook 'after-init-hook 'bm-repository-load)
    ;; Restoring bookmarks when on file find.
    (add-hook 'find-file-hooks 'bm-buffer-restore)
    ;; Saving bookmarks
    (add-hook 'kill-buffer-hook 'bm-buffer-save)
    ;; Saving the repository to file when on exit.
    ;; kill-buffer-hook is not called when Emacs is killed, so we
    ;; must save all bookmarks first.
    (add-hook 'kill-emacs-hook #'(lambda nil
                                   (bm-buffer-save-all)
                                   (bm-repository-save)))

    ;; The `after-save-hook' is not necessary to use to achieve persistence,
    ;; but it makes the bookmark data in repository more in sync with the file
    ;; state.
    (add-hook 'after-save-hook 'bm-buffer-save)
    ;; Restoring bookmarks
    (add-hook 'find-file-hooks   'bm-buffer-restore)
    (add-hook 'after-revert-hook 'bm-buffer-restore)
    ;; The `after-revert-hook' is not necessary to use to achieve persistence,
    ;; but it makes the bookmark data in repository more in sync with the file
    ;; state. This hook might cause trouble when using packages
    ;; that automatically reverts the buffer (like vc after a check-in).
    ;; This can easily be avoided if the package provides a hook that is
    ;; called before the buffer is reverted (like `vc-before-checkin-hook').
    ;; Then new bookmarks can be saved before the buffer is reverted.
    ;; Make sure bookmarks is saved before check-in (and revert-buffer)
    (add-hook 'vc-before-checkin-hook 'bm-buffer-save)
    :bind (("C-c b" . bm-toggle)
           ("C-c /" . bm-next)
           ("C-c '" . bm-previous))))

(defun rogue/init-browse-at-remote ()
  (use-package browse-at-remote
    :defer t))

(defun rogue/init-cricbuzz ()
  (use-package cricbuzz
    :defer t))

(defun rogue/init-enlive ()
  (use-package enlive))

(defun rogue/init-flycheck-mypy ()
  (use-package flycheck-mypy
    :init
    (add-hook 'python-mode-hook (lambda () (setq flycheck-checker 'python-mypy)))))

(defun rogue/init-graphviz-dot-mode ()
  (use-package graphviz-dot-mode
    :defer t))

(defun rogue/init-hackernews ()
  (use-package hackernews
    :bind ("C-c h" . hackernews)))

(defun rogue/init-helm-bm ()
  (use-package helm-bm
    :defer t))

(defun rogue/init-helm-org-rifle ()
  (use-package helm-org-rifle
    :bind ("C-c r" . helm-org-rifle-agenda-files)))

(defun rogue/init-kde ()
  (use-package kde
    :bind (("C-c k" . kde-kalarm-set-org)
           ("C-c s" . kde-kmail-send-default)
           ("C-c x" . kde-explore))))

(defun rogue/init-magithub ()
  (use-package magithub
    :after magit
    :config (magithub-feature-autoinject t)))

(defun rogue/init-molokai-theme ()
  (use-package molokai-theme))

(defun rogue/init-multiple-cursors ()
  (use-package multiple-cursors
    :bind (("C->" . mc/mark-next-like-this)
           ("C-<" . mc/mark-previous-like-this)
           ("C-M-<mouse-1>" . mc/add-cursor-on-click))))

(defun rogue/init-ob-async ()
  (use-package ob-async
    :config (add-to-list
             'org-ctrl-c-ctrl-c-hook
             'org-babel-execute-src-block:async)))

(defun rogue/init-ob-q ()
  (use-package ob-q
    :defer t))

(defun rogue/init-org-journal ()
  (use-package org-journal
    :defer t))

(defun rogue/init-pretty-mode ()
  (use-package pretty-mode
    :config
    (global-pretty-mode t)
    (global-prettify-symbols-mode 1)

    (pretty-deactivate-groups
     '(:equality :ordering :ordering-double :ordering-triple
                 :arrows :arrows-twoheaded :punctuation
                 :logic :sets))

    (pretty-activate-groups
     '(:sub-and-superscripts :greek :arithmetic-nary))))

(defun rogue/init-read-lyrics ()
  (use-package read-lyrics
    :commands (read-lyrics-read-lyrics)))

(defun rogue/init-snakemake-mode ()
  (use-package snakemake-mode
    :defer t))

(defun rogue/init-solarized-theme ()
  (use-package solarized-theme
    :init
    (setq x-underline-at-descent-line t)
    (setq solarized-high-contrast-mode-line t)
    (setq solarized-use-more-italic t)
    (setq solarized-emphasize-indicators t)
    (setq solarized-scale-org-headlines nil)))

(defun rogue/init-spaceline-all-the-icons ()
  (progn
    (use-package spaceline-all-the-icons
      :after spaceline)
    (use-package spaceline
      :after powerline
      :config (setq-default mode-line-format '("%e" (:eval (spaceline-ml-ati)))))))

(defun rogue/init-swiper ()
  (use-package swiper
    :bind (("C-s" . swiper)
           ("C-r" . swiper))))

(defun rogue/init-sx ()
  (use-package sx
    :defer t))

(defun rogue/init-tide ()
  (use-package tide
    :defer t))

(defun rogue/init-tldr ()
  (use-package tldr
    :defer t))

(defun rogue/init-vlf ()
  (use-package vlf
    :defer t))

(defun rogue/init-vue-mode ()
  (use-package vue-mode
    :mode ("\\.vue\\'" . vue-mode)))

(defun rogue/init-wolfram ()
  (use-package wolfram
    :defer t
    :config
    (require 'json)
    (let* ((json-object-type 'hash-table)
           (secrets (json-read-file user-secrets-path)))
      (setq wolfram-alpha-app-id
            (gethash "wolfram-alpha-app-id" secrets)))))

(defun rogue/init-writegood-mode ()
  (use-package writegood-mode
    :defer t))

(defun rogue/init-writeroom-mode ()
  (use-package writeroom-mode
    :defer t))

(defun rogue/init-wttrin ()
  (use-package wttrin
    :defer t
    :config
    (setq wttrin-default-cities '("Amherst?m" "Varanasi?m"))))
