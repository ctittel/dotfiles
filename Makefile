# real username, if this is run as sudo
REAL_USER 	:= $(if $(SUDO_USER), $(SUDO_USER), $(USER))
VIM_DIR 	:= ${HOME}/.vim
EMACS_DIR	:= ${HOME}/.emacs.d

.PHONY: install/common
install/common:
	apt-get install -y trash

.PHONY: install/vim
install/vim:
	apt-get install -y vim

.PHONY: install/emacs
	apt-get install -y emacs

.PHONY: config/git
config/git:
	read -p "Enter global email for git: " GIT_MAIL && git config --global user.email "$${GIT_MAIL}"
	read -p "Enter global name for git: " GIT_NAME && git config --global user.name "$${GIT_NAME}"
	git config --global user.email
	git config --global user.name

.PHONY: config/emacs
config/emacs: delete/${EMACS_DIR}
	ln -s ${CURDIR}/.emacs.d ${EMACS_DIR}	

.PHONY: config/vim
config/vim: delete/${VIM_DIR}/autoload delete/${VIM_DIR}/plugged delete/${VIM_DIR}
	ln -s ${CURDIR}/.vim ${VIM_DIR}
	curl -fLo ${VIM_DIR}/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

.PHONY: config/bashrc
config/bashrc:
	echo '# Add custom important stuff to this file:' >> ${HOME}/.bashrc
	echo . ${CURDIR}/.bashrc >> ${HOME}/.bashrc

# deletes the given path
.PHONY: delete/%
delete/%:
	trash $* || true
