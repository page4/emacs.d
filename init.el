;; set socks5 proxy
(setq url-gateway-method 'socks)
(setq socks-server '("Default server" "127.0.0.1" 1080 5))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (projectile neotree jdee htmlize org-journal solarized-theme org-link-minor-mode pyim tuareg evil evil-leader))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Microsoft YaHei UI Light" :foundry "MS  " :slant normal :weight normal :height 137 :width normal)))))

;; add package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; set faces
(scroll-bar-mode -1)
(tool-bar-mode nil)
;;(transient-mark-mode nil) 

;; auto save sessions
(desktop-save-mode 1)

(require 'solarized-theme)
(load-theme 'solarized-dark t) 
;;(load-theme 'solarized-light t) 

;; evil and evil-leader
(require 'evil-leader)
(require 'evil)
(global-evil-leader-mode)
(evil-mode 1)

(evil-leader/set-leader ",")
(evil-leader/set-key "w" 'save-buffer)
(evil-leader/set-key "c" 'compile)

(evil-leader/set-key
  "s" 'split-window-right
  "h" 'windmove-left 
  "l" 'windmove-right 
  "k" 'windmove-up
  "j" 'windmove-down
  "D" 'delete-window
  "d" 'delete-other-windows)

(evil-leader/set-key
  "e" 'find-file
  "i" '(lambda ()  (interactive) (find-file "~/.emacs.d/init.el"))
  "b" 'switch-to-buffer) 

(defun kill-other-buffers ()
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun open-shell-on-right ()
  (interactive)
   (progn (delete-other-windows)
	  (split-window-right)
	  (shell)))

(defun preview-html ()
  (interactive)
  (let ((buffer (get-buffer-create "*Org HTML Export*")))
    (org-html-export-as-html)
    (shr-render-buffer  buffer)
    (kill-buffer buffer)
    (delete-other-windows)))

(evil-leader/set-key
  "ph" 'preview-html)

(global-set-key "\C-D" 'open-shell-on-right)

;; org-mode
;; The following lines are always needed.  Choose your own keys
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
     
;; chinese input method
;;(setq current-language-environment "Chinese-GBK")
(require 'pyim)
(require 'pyim-wbdict)
(setq default-input-method 'pyim)
(pyim-wbdict-gbk-enable)
;;(pyim-wbdict-gb2312-enable)
(setq pyim-default-scheme 'wubi)
(add-hook 'emacs-startup-hook '(lambda () (pyim-start "pyim")))

(global-set-key (kbd "C-SPC") 'toggle-input-method)

(setq neo-smart-open t)
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)

(setq projectile-switch-project-action 'neotree-projectile-action)

(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (ignore-errors (projectile-project-root)))
	(file-name (buffer-file-name)))
    (neotree-show)
    (if project-dir
	(if (neo-global--window-exists-p)
	    (progn
	      (neotree-dir project-dir)
	      (neotree-find file-name)))
      (message "Could not find git project root."))))

(defun neotree-file () 
  (interactive)
  (progn
    (projectile-find-file)
    (neotree-project-dir)))

(evil-leader/set-key
  "nt" 'neotree-toggle
  "nr" 'neotree-project-dir
  "nf" 'neotree-file)
