#!/usr/bin/ruby

#printf color palet
class PC #printf_colors
  STYLES = { :default => 0, :bold => 1, :under => 4, :flash => 5, :invert => 7}
  COLORS = { :black => 30, :red => 31, :green => 32, :yellow => 33, :blue => 34, :purple => 35, :waterblue => 36, :white => 37}
  BGCOLORS = { :black => 40, :red => 41, :green => 42, :yellow => 43, :blue => 44, :purple => 45, :waterblue => 46, :white => 47}
  DEFAULT_SET = "\x1b[0m"

  #ONLY return COLORS. set color, style, bgcolors
  #style, color, bgcolors is default.
  #ex1 PC::c("hoge", :style => nil, :color => :red, :bgcolor => :nil) #set from hash
  #ex2 PC::c("hoge2", nil, :red, nil) #style, color, bgcolor
  #ex3 PC::c("hoge3", 0, 30, 40) #set from direct(style, color, bgcolor)
  def self.c(*styles)
    tmp = "\x1b["
    if styles[0].is_a?(Hash)
      styles = styles[0]
      return value if styles[:style].nil? && styles[:color].nil? && styles[:bgcolor].nil?
      tmp += "#{STYLES[styles[:style]]};" unless styles[:style].nil?
      tmp += "#{COLORS[styles[:color]]};" unless styles[:color].nil?
      tmp += "#{BGCOLORS[styles[:bgcolor]]};" unless styles[:bgcolor].nil?
    elsif styles[0].is_a?(Symbol) or styles[0].is_a?(String) or styles[0].is_a?(NilClass)
      return value if styles[0].nil? && styles[1].nil?  && styles[2].nil? 
      styles.map{ |s| s.to_sym unless s.nil? and s.to_s.empty? }
      tmp += "#{STYLES[styles[0]]};" unless styles[0].nil?
      tmp += "#{COLORS[styles[1]]};" unless styles[1].nil?
      tmp += "#{BGCOLORS[styles[2]]};" unless styles[2].nil?
    elsif styles[0].to_s =~ /\d{1,}/ #only number
      styles.each do |s|
        next if s.nil?
        tmp+="#{s};"
      end
    else
      raise "#{styles.inspect} is wrong argumens."
    end
    tmp.chop!
    tmp += "m"
    tmp
  end

  #return set value to select color.
  def self.cv(value, *styles)
    "#{c(*styles)}#{value}#{DEFAULT_SET}"
  end
  #return set to default color.
  def self.d
    DEFAULT_SET
  end


end
