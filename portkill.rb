#!/usr/bin/ruby

require 'optparse'

#raise ENV["USER"].inspect
#raise ENV["_"].inspect


##############################################
# portkill.rb 09/05/01
# Usage: portkill.rb -p PORT
# (Only root can run this program.)
#############################################



unless ENV["USER"] == "root"
	puts "root required.(please su or sudo!)"
	exit(-1)
end

port = 0
ARGV.options do |opt|
	opt.on('-p PORT', 'port number.'){ |v| port = v.to_i }
	opt.parse!
end

if port.to_i.zero?
	puts "Usage: portkill [options] \n\t-p PORT\t port number."
	exit(-1)
end

puts "port #{port} process is searching now..."
finds = []
first_line = nil
ports = %x(lsof -i -n -P).split(/\n/)
ports.each_with_index do |port_line, i|
	if i.zero?
		first_line = port_line
		next
	end
	split_line = port_line.split(/\s+/)
	_port = nil
	#raise line.inspect
	split_line.each do |s|
		if s.split(":").size > 1
			_port = s.split(":")[1].to_i
			#tmps << _port
		end
	end
	if _port == port
		finds << { :description => port_line, :port => _port, :pid => split_line[1].to_i }
	end
end

if finds.empty?
	puts "port #{port} process doesn't find in all proceses!"
	exit(0)
end


puts "find #{finds.size} count processes."
puts first_line
finds.each{ |k| puts "[find] #{k[:description]}"}

finds.each do |f|
	puts "#{f[:pid]} is killing now.."
	%x(kill #{f[:pid]})
end

puts "done."
exit(0)
