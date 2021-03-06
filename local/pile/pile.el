;;; pile.el --- Pile management

;; Copyright (c) 2018 Abhinav Tushar

;; Author: Abhinav Tushar <lepisma@fastmail.com>
;; Version: 0.0.1
;; Package-Requires: ((emacs "25"))
;; URL: https://github.com/lepisma/pile.el

;;; Commentary:

;; Org pile management
;; This file is not a part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'dash)
(require 'dash-functional)
(require 'f)
(require 'pile-index)
(require 'org)
(require 'ox-html)
(require 'ox-publish)
(require 's)


(defcustom pile-source nil
  "Source files for pile")

(defcustom pile-output nil
  "Output directory for pile")

(defun pile--fix-sitemap (list)
  "Walk over the list to remove index.org items"
  (let ((ignore-patterns '("/index.org"
                           "allpages.org"
                           "org-test.org")))
    (->> list
       (-remove (lambda (it)
                  (and (consp it) (= (length it) 1)
                       (-any (-cut s-contains? <> (car it)) ignore-patterns))))
       (-map (lambda (it) (if (consp it) (pile--fix-sitemap it) it))))))

(defun pile-sitemap (title list)
  (concat "#+TITLE: Sitemap\n\n" (org-list-to-org (pile--fix-sitemap list))))

(defun pile-sitemap-entry (entry style project)
  (cond ((not (directory-name-p entry))
         (format "[[file:%s][%s]]"
                 entry
                 (org-publish-find-title entry project)))
        ((eq style 'tree)
         (let ((index-file (f-join entry "index.org")))
           (format "[[file:%s][%s]]"
                   index-file
                   (org-publish-find-title index-file project))))
        (t entry)))

;;;###autoload
(defun pile-clear-cache ()
  "Clear org-publish-cache"
  (interactive)
  (setq org-publish-cache nil)
  (let ((cache-root (f-full "~/.emacs.d/.cache/.org-timestamps/")))
    (->> '("pile-pages.cache" "pile-static.cache")
       (-map (-cut f-join cache-root <>))
       (-filter #'f-exists?)
       (-map #'f-delete))))

(defalias 'pile-publish-current-file #'org-publish-current-file)

;;;###autoload
(defun pile-publish ())

;;;###autoload
(defun pile-clear-output ()
  "Remove files in output directory which are not in input")

(defun pile-setup ()
  "Setup for pile"
  (let ((preamble "<header>
  <div class='site-title'>
    <a href='/'>
      <img src='/assets/images/avatar32.png'>
    </a>
  </div>
  <div class='site-nav'>
    <a href='/pile'> pile</a>
    <a href='/feed.xml'> feed</a>
    <a href='/archive'> blog</a>
    <a href='/about'> about</a>
  </div>
  <div class='clearfix'>
  </div>
</header>

<div class='page-header'>
  <div class='page-meta small'>
    Last modified: %d %C
  </div>
  <h1>%t</h1>
</div>")
        (postamble "<footer id='footer'></footer>"))
    (setq org-publish-project-alist
          `(("pile-pages"
             :auto-sitemap t
             :sitemap-filename "sitemap.org"
             :sitemap-title "Sitemap"
             :sitemap-format-entry pile-sitemap-entry
             :sitemap-function pile-sitemap
             :base-directory ,pile-source
             :base-extension "org"
             :recursive t
             :publishing-directory ,pile-output
             :publishing-function org-html-publish-to-html
             :htmlized-source nil
             :html-checkbox-type unicode
             :html-doctype "html5"
             :html-html5-fancy t
             :html-postamble ,postamble
             :html-preamble ,preamble)
            ("pile-static"
             :base-directory ,pile-source
             :base-extension ".*"
             :exclude ".*\.org"
             :recursive t
             :publishing-directory ,pile-output
             :publishing-function org-publish-attachment)
            ("pile" :components ("pile-pages" "pile-static")))
          org-html-htmlize-output-type 'inline-css)))

(provide 'pile)

;;; pile.el ends here
