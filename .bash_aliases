alias ll="ls -al"

alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"

path_concat () {
	if [ -z $1 ] || [ -z $2 ] ; then
		return 1
	fi
	if ! [[ $1 =~ ^(\/?[a-zA-Z]+)+$ ]] && ! [[ $2 =~ ^(\/?[a-zA-Z]+)+$ ]] ; then
		return 2
	fi
	if [[ $2 =~ ^\/ ]] ; then
		echo $1$2
	else
		echo $1/$2
	fi
	return 0
}

proj_path () {
	if [ -z $1 ] ; then
		return 1
	fi
	path_concat $WORKON_HOME $1
}

venv_path () {
	if [ -z $1 ] ; then
		return 1
	fi
	path_concat $(proj_path $VENV_FOLDER) $1
}

venv () {
	if [ -z $1 ] ; then
		echo "Please provide name for new virtualenv"
		return 1
	fi
	if [ -z $WORKON_HOME ] ; then
		echo "Set WORKON_HOME to the workspace dir"
		return 2
	fi
	if [ -z $VENV_FOLDER ] ; then
		echo "Set VENV_FOLDER to the virutalenv dir"
		return 3
	fi
	proj_path=$(proj_path $1)
	venv_path=$(venv_path $1)
	mkdir -p $proj_path
	mkdir -p $venv_path
	virtualenv $(venv_path $1)
	cd $proj_path
}

workon () {
	if [ -z $1 ] ; then
		return 1
	fi
	proj_path=$(proj_path $1)
	venv_path=$(venv_path $1)
	source $(path_concat $venv_path bin/activate)
	cd $proj_path
}

rmvenv () {
	if [ -z $1 ] ; then
		return 1
	fi
	venv_path=$(venv_path $1)
	echo "Virtualenv path: $venv_path"
	while true; do
		read -p "Do you want to delete virtualenv for $1? [y/n]: " yn
		case $yn in 
			[Yy]* ) rm -rf $venv_path; break;;
			[Nn]* ) exit;;
			* ) echo "Please answer yes or no";;
		esac
	done
}
