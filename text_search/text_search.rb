#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'pc'

#############################################################
# text_search.rb
#   updated  09/09/11
# All files text which you select directory are searched by your "search words".
###########################################################

#TextSearch -- textsearch
class TextSearch
  require 'nkf'
  require 'kconv'

  #set constant values
  IGNORE_FILES = [".", ".."] #ignore filenames (complete match)
  SHOW_TEXT_RANGE = 2 #if find match, it shows text from line-SHOW_TEXT_RANGE to line+SHOW_TEXT_RANGE


  attr_reader :searchwords, :searchdir, :commands, :is_recursive
  #searchwords : set search_word
  #commands : set available commands (see description)
  #searchdir : set start search dir
  def initialize(open_struct)
    #self.force_encoding 'UTF-8'
    #Encoding.default_external = 'UTF-8'
    @searchwords = open_struct.searchwords
    puts open_struct.searchdir
    @searchdir = open_struct.searchdir
    @is_recursive = open_struct.is_recursive
  end

  def check_values
    if @searchwords.to_s.empty?      
      raise ArgumentError, "検索語句が指定されていません。"
    end
  end


  #file is binary, ascii, or others?
  def self.is_text?(filename)
    case NKF.guess(filename)
    when NKF::BINARY then
      #puts "===> it is binary file!"
      return false;
    when NKF::JIS then 
      #puts "===> it is jis file!"
    when NKF::SJIS then
      #puts "===> it is sjis file!"
    when NKF::UNKNOWN then
      #puts "===> it is unknwon file!"
      return false;
    when NKF::ASCII then
      #puts "===> it is ascii file!"
    when NKF::UTF8 then
      #puts "===> it is utf8 file!"
    when NKF::UTF16 then
      #puts "===> it is utf16 file!"
    end
    true
  end
  
  def self.description
    puts "Usage: ruby text_search.rb <options> <regex pattern>"
  end

  def dir_foreach(dirname)
    #puts "start: dirname => #{dirname}"
    #raise "#{dirname} is not a dir!" unless File::ftype("#{dirname}") == "directory"
    Dir::foreach(dirname) do |filename|
      next if IGNORE_FILES.include?(filename)
      fullpath = "#{dirname}/#{filename}".gsub(/\/{1,}/, "/")
      #puts "filetype start => #{filename}, dirname #{dirname}, fullpath :#{fullpath}"
      case File::ftype(fullpath)
      when "directory"
        if @is_recursive
          #gen_dir = (dirname == @searchdir) ? filename : dirname + "/" + filename
          gen_dir = dirname + "/" + filename
          #puts "dir : #{filename}, generate_dir => #{gen_dir} "
          dir_foreach(gen_dir)
        end
        next
      when "file"      
      else
        next
      end
      begin
        fullpath = fullpath.toutf8
        File::open(fullpath, "r") do |fopen|
          data = []
          fopen.each_with_index do |line, i|
            break if i.zero? && !is_text?(line)
            data << line
          end
          unless data.empty?
            data.map{ |d| d.to_s.toutf8 }
            data.each_with_index do |line,i|
              if line =~ /#{@searchwords}/
                puts "#{PC::c(:color=>:green)}### #{fullpath} on line #{i+1}#{PC::d}"
                (i-SHOW_TEXT_RANGE..i+SHOW_TEXT_RANGE).to_a.each do |l|
                  next if l < 0
                  if l==i
                    puts "#{PC::c(nil, :red)}##{l+1}#{PC::d}\t#{data[l].gsub(/#{@searchwords}/, "#{PC::c(nil,:red)}#{@searchwords}#{PC::d}")}"
                  else
                    puts "##{l+1}\t#{data[l]}"
                  end
                end
                #break
              end
            end
          end
        end
      rescue Errno::EACCES => e #e.g. permission denied
        puts PC::cv(" [WARNING]   On #{fullpath}, #{e.message}", :color => :red)
        #puts "\x1b[1;31m[WARNING] #{e.message}\x1b[0m"
        next
      rescue ArgumentError => e #e.g. invalid byte sequence in UTF-8 (ArgumentError)
        puts PC::cv(" [WARNING]   On #{fullpath}, #{e.message}", :color => :red)
        next
      end
    end

  end


  #start search
  def start
    puts @searchdir
    dir_foreach(@searchdir)
    # Dir::foreach(@search_dir) do |filename|
    #   #next if File::extname(filename) == ""
    #   next if IGNORE_FILES.include?(filename)
    #   #puts "#{filename}"
    #   case File::ftype(filename)
    #   when "directory"
    #     puts "dir : #{filename}"
    #     next
    #   when "file"      
    #   else
    #     next
    #   end
    #   begin
    #     File::open(filename, "r") do |fopen|
    #       data = []
    #       fopen.each_with_index do |line, i|
    #         break if i.zero? && !is_text?(line)
    #         data << line
    #       end
    #       unless data.empty?
    #         data.map{ |d| d.to_s.toutf8 }
    #         data.each_with_index do |line,i|
    #           if line =~ /#{@searchwords}/
    #             puts "#{PC::c(:color=>:green)}### #{filename.toutf8} on line #{i+1}#{PC::d}"
    #             (i-SHOW_TEXT_RANGE..i+SHOW_TEXT_RANGE).to_a.each do |l|
    #               next if l < 0
    #               if l==i
    #                 puts "#{PC::c(nil, :red)}##{l+1}#{PC::d}\t#{data[l].gsub(/#{@searchwords}/, "#{PC::c(nil,:red)}#{@searchwords}#{PC::d}")}"
    #               else
    #                 puts "##{l+1}\t#{data[l]}"
    #               end
    #             end
    #             #break
    #           end
    #         end
    #       end
    #     end
    #   rescue Errno::EACCES => e #e.g. permission denied
    #     puts PC::cv(" [WARNING]   #{e.message}", :color => :red)
    #     #puts "\x1b[1;31m[WARNING] #{e.message}\x1b[0m"
    #     next
    #   end


    #end

  end

  
  #check syntax search_words & params
  def has_right_syntax?
    #check syntax
    if @searchwords.to_s.empty?
      return false
    end    
    true
  end
end


#file is binary, ascii, or others?
def is_text?(line)
  case NKF.guess(line)
  when NKF::BINARY then
   #puts "===> it is binary file!"
   return false;
  when NKF::JIS then 
    #puts "===> it is jis file!"
  when NKF::SJIS then
    #puts "===> it is sjis file!"
  when NKF::UNKNOWN then
    #puts "===> it is unknwon file!"
    return false;
  when NKF::ASCII then
    #puts "===> it is ascii file!"
  when NKF::UTF8 then
    #puts "===> it is utf8 file!"
  when NKF::UTF16 then
    #puts "===> it is utf16 file!"
  end
  true
end


