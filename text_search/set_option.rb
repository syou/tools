#!/usr/bin/ruby
# -*- coding: utf-8 -*-

#Thanks to reference url:
#http://www.ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html

require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'kconv'
require 'pp'

class SetOption
  VERSION = "text_search v0.1"
  CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
  CODE_ALIASES = {  "jis" => "iso-2022-jp", "sjis" => "shift_jis" }

  #
  # Return a structure describing the options.
  #
  def self.parse!(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.is_recursive = false #再帰的検索
    options.searchdir = "./" #検索ディレクトリの指定
    options.searchwords = nil #検索語句の指定。or regex
    options.encoding = "utf8" #エンコーディング

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: #{$0} [searchwords(regex)] [specific options]"
      opts.separator "Specific options:"

      # Recursive Directory
      opts.on("-r", "--recursive",
              "指定ディレクトリ以下の再帰検索を行うかを指定(デフォルト:false)") do |v|
        options.is_recursive = v
      end

      # Optional argument; multi-line description.
      # Search Directory
      opts.on("-s", "--search_dir [search_directory]",
              "検索ディレクトリの指定(デフォルト:実行ディレクトリ)", "") do |search_dir|
        options.searchdir = search_dir
      end

#      opts.separator ""
#      opts.separator "Common options:"

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      if ARGV.empty?
        puts opts 
        exit
      end

      opts.on_tail("-h", "--help", "ヘルプの表示") do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on_tail("-v", "--version", "バージョンの表示") do
        puts VERSION
        exit
      end
    end

    opts.parse!(args)
    options.searchwords = ARGV[0].to_s.toutf8

    options
  end  # parse()

end  # class OptparseExample

#DEBUG
#options = SetOption.parse!(ARGV)
#pp options

