#!/bin/bash

word=$(echo $(xsel) | xargs | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]')
urlhead='http://www.merriam-webster.com/dictionary'
exec xdg-open "$urlhead/$word" &>/dev/null

# vim: set ft=sh:

