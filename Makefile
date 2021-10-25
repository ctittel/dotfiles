# real username, if this is run as sudo
REAL_USER 	:= $(if $(SUDO_USER), $(SUDO_USER), $(USER))
VIM_DIR 	:= ${HOME}/.vim
EMACS_DIR	:= ${HOME}/.emacs.d
SHUTDOWN_SCRIPT_LOCATION := /etc/rc0.d/Kct-exit-script.sh

.PHONY: install/common
install/common:
	apt-get install -y trash ripgrep

.PHONY: install/vim
install/vim: delete/${VIM_DIR}/autoload delete/${VIM_DIR}/plugged delete/${VIM_DIR}
	apt-get install -y vim
	ln -s ${CURDIR}/.vim ${VIM_DIR}
	curl -fLo ${VIM_DIR}/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

.PHONY: install/emacs
install/emacs: delete/${EMACS_DIR}
	apt-get install -y emacs
	ln -s ${CURDIR}/.emacs.d ${EMACS_DIR}	

# See https://unix.stackexchange.com/questions/350637/run-script-at-shutdown
.PHONY: install/exit_script
install/exit_script:
	echo "Registering exit_script to be executed on shutdown"
	rm -f "${SHUTDOWN_SCRIPT_LOCATION}"
	sudo ln -s $$(pwd)/exit-script.bash "${SHUTDOWN_SCRIPT_LOCATION}"

.PHONY: install/scripts
install/scripts:
	cp -f "$$(pwd)/root-scripts/fzf-apt-install" /usr/local/bin
	cp -f "$$(pwd)/root-scripts/fzf-apt-remove" /usr/local/bin
	cp -f "$$(pwd)/root-scripts/fzf-process-kill" /usr/local/bin

.PHONY: config/bashrc
config/bashrc:
	echo '# Add custom important stuff to this file:' >> ${HOME}/.bashrc
	echo ". ${CURDIR}/bashrc.bash" >> ${HOME}/.bashrc

.PHONY: config/git
config/git:
	read -p "Enter global email for git: " GIT_MAIL && git config --global user.email "$${GIT_MAIL}"
	read -p "Enter global name for git: " GIT_NAME && git config --global user.name "$${GIT_NAME}"
	git config --global user.email
	git config --global user.name


# deletes the given path
.PHONY: delete/%
delete/%:
	trash $* || true
