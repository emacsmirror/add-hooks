;;; add-hooks.el --- Macro for setting multiple hooks

;; Copyright (C) 2017 Nick McCurdy

;; Author: Nick McCurdy <nick@nickmccurdy.com>
;; Created: 22 Jan 2017
;; Version: 1.1.0
;; Keywords: lisp
;; Homepage: https://github.com/nickmccurdy/add-hooks
;; Package-Requires: ((emacs "24.3"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the gnu general public license as
;; published by the free software foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; without any warranty; without even the implied warranty of
;; merchantability or fitness for a particular purpose.  see the gnu
;; general public license for more details.

;; You should have received a copy of the gnu general public license
;; along with gnu emacs; see the file copying.  if not, write to the
;; free software foundation, inc., 59 temple place - suite 330,
;; boston, ma 02111-1307, usa.

;;; Commentary:

;; Typically, you would need to call `add-hook' multiple times with
;; similar arguments to declare multiple functions for one hook, or
;; vice versa.  The `add-hooks' function tidies up duplicate hook and
;; function names into a single declarative call (inspired by the
;; `bind-key' package).

;;; Code:

(defun add-hooks-listify (object)
  "If OBJECT is a list, return it, else wrap it in a list."
  (if (listp object) object (list object)))

;;;###autoload
(defun add-hooks (pairs)
  "Call `add-hook' on each cons pair in PAIRS.

Each pair has a `car' for setting hooks and a `cdr' for setting
functions to add to those hooks.  Either side of the pair can be
a single symbol or a list of symbols, in which case a function
can be added to multiple hooks and/or multiple functions can be
added to a hook.

Usage:

  (add-hooks '((hook-or-hooks . function-or-functions)...))

Example:

  (add-hooks '(((css-mode-hook sgml-mode-hook) . emmet-mode)))

Result:

  ELISP> css-mode-hook
  (emmet-mode)

  ELISP> sgml-mode-hook
  (emmet-mode)"
  (mapc (lambda (pair)
          (let ((hooks (add-hooks-listify (car pair)))
                (functions (add-hooks-listify (cdr pair))))
            (mapc (lambda (hook)
                    (mapc (lambda (function)
                            (add-hook hook function))
                          functions))
                  hooks)))
        pairs))

(provide 'add-hooks)
;;; add-hooks.el ends here
