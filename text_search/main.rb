#!/usr/bin/ruby

require 'text_search'
require 'set_option'

options = SetOption.parse!(ARGV)

#search_words = ARGV[0]
text_search = TextSearch.new(options)

unless text_search.has_right_syntax?
  TextSearch.description
  exit(0)
end

text_search.start



exit(0)
