#!/bin/sh
# init: Initialize a new issue repository {{{1
usage_init()
{
  cat <<\USAGE_new_EOF
gi init usage: git issue init [-e]
-e	Use existing project's Git repository
USAGE_new_EOF
  exit 2
}

sub_init()
{
  local existing

  while getopts e flag ; do
    case $flag in
    e)
      existing=1
      ;;
    ?)
      usage_init
      ;;
    esac
  done
  shift $((OPTIND - 1));

  test -d .issues && error 'An .issues directory is already present'
  mkdir .issues || error 'Unable to create .issues directory'
  cdissues
  if ! [ "$existing" ] ; then
    git init -q || error 'Unable to initialize Git directory'
  fi

  # Editing templates
  touch config || error 'Unable to create configuration file'
  mkdir templates || error 'Unable to create the templates directory'
  cat >templates/description <<\EOF
# Start with a one-line summary of the issue.  Leave a blank line and
# continue with the issue's detailed description.
#
# Remember:
# - Be precise
# - Be clear: explain how to reproduce the problem, step by step,
#   so others can reproduce the issue
# - Include only one problem per issue report
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the issue addition.
EOF

  cat >templates/comment <<\EOF
# Please write here a comment regarding the issue.
# Keep the conversation constructive and polite.
# Lines starting with '#' will be ignored, and an empty message aborts
# the issue addition.
EOF
  cat >README.md <<\EOF
This is an distributed issue tracking repository based on Git.
Visit [git-issue](https://github.com/dspinellis/git-issue) for more information.
EOF
  git add config README.md templates/comment templates/description
  commit 'gi: Initialize issues repository' 'gi init'
  echo "Initialized empty issues repository in $(pwd)"
}

# new: Open a new issue {{{1
usage_new()
{
  cat <<\USAGE_new_EOF
gi new usage: git issue new [-s summary]
USAGE_new_EOF
  exit 2
}
sub_new()
{
  local summary sha path

  while getopts s:c: flag ; do
    case $flag in
    s)
      summary="$OPTARG"
      ;;
    c)
      create=$OPTARG
      ;;
    ?)
      usage_new
      ;;
    esac
  done
  shift $((OPTIND - 1));

  trans_start
  commit 'gi: Add issue' 'gi new mark'
  sha=$(git rev-parse HEAD)
  path=$(issue_path_full "$sha")
  mkdir -p "$path" || trans_abort
  echo open >"$path/tags" || trans_abort
  if [ "$summary" ] ; then
    echo "$summary" >"$path/description" || trans_abort
  else
    cp templates/description "$path/description" || trans_abort
    edit "$path/description" || trans_abort
  fi
  git add "$path/description" "$path/tags" || trans_abort
  commit 'gi: Add issue description' "gi new description $sha"
  echo "Added issue $(short_sha "$sha")"
  # export issue immediately
  if [ -n "$create" ] ; then
    # shellcheck disable=SC2086
    # Rationale: We want word splitting
    create_issue -n "$sha" $create
  fi
}
# help: display help information {{{1
usage_help()
{
  cat <<\USAGE_help_EOF
gi help usage: git issue help
USAGE_help_EOF
  exit 2
}
sub_help()
{
  #
  # The following list is automatically created from README.md by running
  # make sync-docs
  # DO NOT EDIT IT HERE; UPDATE README.md instead
  #
  cat <<\USAGE_EOF
usage: git issue <command> [<args>]
The following commands are available:
Start an issue repository
   clone      Clone the specified remote repository.
   init       Create a new issues repository in the current directory.
Work with an issue
   new        Create a new open issue (with optional -s summary and -c "provider user repo" for github/gitlab export).
   show       Show specified issue (and its comments with -c).
   comment    Add an issue comment.
   edit       Edit the specified issue's (or comment's with -c) description
   tag        Add (or remove with -r) a tag.
   milestone  Specify (or remove with -r) the issue's milestone.
   weight     Specify (or remove with -r) the issue's weight.
   duedate    Specify (or remove with -r) the issue's due date.
* timeestimate: Specify (or remove with -r) a time estimate for this issue.
   timespent  Specify (or remove with -r) the time spent working on an issue so far.
   assign     Assign (or remove -r) an issue to a person.
   attach     Attach (or remove with -r) a file to an issue.
   watcher    Add (or remove with -r) an issue watcher.
   close      Remove the open tag, add the closed tag
Show multiple issues
   list       List open issues (or all with -a).
* list -l formatstring: This will list issues in the specified format, given as an argument to -l.
Work with multiple issues
* filter-apply command: Run command in every issue directory. The following environment variables will be set:
Synchronize with remote repositories
   push       Update remote Git repository with local changes.
   pull       Update local Git repository with remote changes.
   import     Import/update GitHub/GitLab issues from the specified project.
   create     Create the issue in the provided GitHub repository.
   export     Export modified issues for the specified project.
   exportall  Export all open issues in the database (-a to include closed ones) to GitHub/GitLab. Useful for cloning whole repositories.
Help and debug
   help       Display help information about git issue.
   log        Output a log of changes made
   git        Run the specified Git command on the issues repository.
USAGE_EOF
}
subcommand="$1"
if ! [ "$subcommand" ] ; then
  sub_help
  exit 1
fi

shift
case "$subcommand" in

  create)
    create_issue "$@"
    ;;
  init) # Initialize a new issue repository.
    sub_init "$@"
    ;;
esac
