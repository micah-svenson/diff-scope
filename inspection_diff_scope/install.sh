#!/usr/bin/env bash

AUTOMATIONBIN='/usr/local/automation'

#link the generate_diff_scope script to diffscope executable in AUTOMATIONBIN
ln -sf $PWD'/generate_diff_scope.sh' $AUTOMATIONBIN'/bin/diffscope'
