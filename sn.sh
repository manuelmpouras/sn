#!/bin/sh

sub_new()
{
Echo Perfect
}
subcommand="$1"

shift
case "$subcommand" in

  create)
    create_new "$@"
    ;;
 esac
