# real username, if this is run as sudo
REAL_USER 	:= $(if $(SUDO_USER), $(SUDO_USER), $(USER))
VIM_DIR 	:= ${HOME}/.vim
EMACS_DIR	:= ${HOME}/.emacs.d

.PHONY: git
git:
	read -p "Enter global email for git: " GIT_MAIL && git config --global user.email "$${GIT_MAIL}"
	read -p "Enter global name for git: " GIT_NAME && git config --global user.name "$${GIT_NAME}"
	git config --global user.email
	git config --global user.name

.PHONY: emacs
emacs: delete/${EMACS_DIR}
	ln -s ${CURDIR}/.emacs.d ${EMACS_DIR}	

.PHONY: vim
vim: delete/${VIM_DIR}/autoload delete/${VIM_DIR}/plugged delete/${VIM_DIR}
	ln -s ${CURDIR}/.vim ${VIM_DIR}
	curl -fLo ${VIM_DIR}/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

# deletes the given path
.PHONY: delete/%
delete/%:
	trash $* || true
