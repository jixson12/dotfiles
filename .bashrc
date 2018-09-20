export LC_CTYPE=C
export LANG=C
export LSCOLOR="EHfxcxdxBxegecabagacad"
export PYTHONIOENCODING=utf-8
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

cs_region=us-west-2

function addcred() {
    read -p 'Table: ' table
    read -sp 'Key: ' key
    echo
    if [ -z "$table" -o $(credstash -t $table -r $cs_region keys | grep ResourceNotFoundException) ]; then
        echo "Table not found"
        exit 1
    fi
    if [ $# -eq 2 ]; then
        credstash -t $table -r $cs_region put $1 $2 -k $key
    else
        echo "Must pass a keyname and a value"
    fi
}

function getcred() {
    read -p 'Table: ' table
    echo
    if [ -z "$table" -o $(credstash -t $table -r $cs_region keys | grep ResourceNotFoundException) ]; then
        echo "Table not found"
        exit 1
    fi
    if [ $# -eq 1 ]; then
        credstash -t $cs_sec_table -r $cs_region get $1
    else
        echo "Must pass a key name"
    fi
}

function gitmm() {
    stash=false
    if [ ! $(git status | grep "nothing to commit, working tree clean") ]; then
        git stash
        stash=true
    fi
    curr_branch=$(git branch | grep \* | cut -d' ' -f2)
    git checkout master
    git pull
    git checkout $curr_branch
    git merge master --no-edit
    if [ $stash ]; then
        git stash apply
    fi
}

alias ls='ls -GH'
alias ll='ls -al'

export PATH="/Library/Python/2.7/site-packages:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"

eval "$(direnv hook bash)"

export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

