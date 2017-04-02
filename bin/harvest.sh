#!/usr/bin/env bash
#export DISPLAY=:0
#cd ${pwd}/..
source ${HOME}/.rvm/environments/ruby-2.3.3

APP_ENV=production bundle exec ruby harvest.rb
