# Prompt Mode
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='❱ '
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_STATUS_VERBOSE=false

# Prompt Figures
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
	os_icon
	dir
	direnv
	vcs
	fnm
	rbenv
	pyenv
	anaconda
	goenv
	go_version
	asdf
	aws
	kubecontext
	docker_machine
	background_jobs
	command_execution_time
	status
	)

# Truncating Long Directories
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# POWERLEVEL9K_SHORTEN_DELIMITER=""
# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
