# -----------------------------------------------------------------------------
# BASH PROFILE
#
# Andreas Philippi
# https://github.com/anphil
# If you find something useful, do whatever you want with it!
# -----------------------------------------------------------------------------

export DOTFILES_ROOT="${HOME}/Documents/Dotfiles"

# -----------------------------------------------------------------------------
# Variables for colorful console output.
# Adapted from: http://unix.stackexchange.com/a/124408
# -----------------------------------------------------------------------------

# Regular
export C_BLK='\033[0;30m'  # Black
export C_RED='\033[0;31m'  # Red
export C_GRN='\033[0;32m'  # Green
export C_YLW='\033[0;33m'  # Yellow
export C_BLU='\033[0;34m'  # Blue
export C_PUR='\033[0;35m'  # Purple
export C_CYN='\033[0;36m'  # Cyan
export C_WHT='\033[0;37m'  # White

# Bold
export C_BBL='\033[1;30m' # Black
export C_BRE='\033[1;31m' # Red
export C_BGR='\033[1;32m' # Green
export C_BYL='\033[1;33m' # Yellow
export C_BBL='\033[1;34m' # Blue
export C_BPU='\033[1;35m' # Purple
export C_BCY='\033[1;36m' # Cyan
export C_BWH='\033[1;37m' # White

# Reset
export C_RST='\033[0m'

# -----------------------------------------------------------------------------
# Install rbenv
# -----------------------------------------------------------------------------

eval "$(rbenv init -)"

# -----------------------------------------------------------------------------
# Paths
# -----------------------------------------------------------------------------

# PATH split up to easier to read and manage. Built up reversely, i.e. the
# first segment will be the last in the final path. That allows us to keep
# the original path, but give priority to custom locations.
PATH="${PATH}:."
PATH="./node_modules/.bin:${PATH}"
PATH="${DOTFILES_ROOT}/bin:${PATH}"
PATH="/Users/andreas/Documents/Projekte/Make-Project:${PATH}"

export PATH

# -----------------------------------------------------------------------------
# Alias laziness
# -----------------------------------------------------------------------------

# Spare me three characters when going up one level
alias ..="cd .."

# Override ls to be colorful and show only one item per line
alias ls="ls -G1"

# Shorthand for detailed ls output
alias ll="ls -l"

# Shorthands for actions for the bookmarks script
alias b=". bookmarks"
alias bl="bookmarks list"
alias bc="bookmarks create"
alias bd="bookmarks delete"

# Shorthand to open the current directiory in finder
alias o="open ."

# -----------------------------------------------------------------------------
# Functions – everything too much for an alias and to little for a script
# -----------------------------------------------------------------------------

# Creates an executable file in the current directory
function new-script
{
  touch "$1" && chmod +x "$1" && echo "#!/bin/bash" > "$1"
}

# Creates a new directory and cd into it
function cdnew
{
  mkdir "$1" && cd "$1"
}

# -----------------------------------------------------------------------------
# Prompt configuration
# -----------------------------------------------------------------------------

# Awkwardly formatting of NPM package info and Git branch name. But this way,
# we avoid unnecessary spaces between the previous and following prompt
# segments in case we're not in a package, a repository or neither of both.

# Reads name and version of the NPM package (in case we're in one). Requires
# node to be installed (obviously).
function get-npm-package-info
{
  node -e "var pack=require('./package.json');
  console.log(pack.name + ' ' + pack.version);" 2> /dev/null
}

# Puts brackets around the package name if not empty.
function parse-npm-package-info
{
  get-npm-package-info | sed -e "s/\(.*\)/(\1)/"
}

# Reads the current Git branch name and wraps it in brackets (if not empty)
function parse-git-branch-name
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Wrap prompt creation in a function to make it easier to read and manage
function get-prompt
{
  # Host name + working directory
  p="\h:\W"

  # Git branch name
  p="${p}\[${C_GRN}\]\$(parse-git-branch-name)\[${C_RST}\]"

  # NPM package name
  p="${p}\[${C_BLU}\]\$(parse-npm-package-info)\[${C_RST}\]"

  # username + $
  p="${p} \u\$ "

  echo "$p"
}

export PS1="$(get-prompt)"

# -----------------------------------------------------------------------------
# Say hello. Prints a colorful cow saying words of wisdom. Requires fortune,
# cowsay and lolcat to be installed:
#
# `brew install fortune cowsay
# gem install lolcat`
# -----------------------------------------------------------------------------

fortune|cowsay|lolcat
echo ""
