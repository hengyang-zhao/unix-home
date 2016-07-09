#!/bin/bash

word=$(echo $(xsel) | xargs | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]')
urlhead='http://dictionary.cambridge.org/us/dictionary/english-chinese-traditional'
exec xdg-open "$urlhead/$word" &>/dev/null

# vim: set ft=sh:

