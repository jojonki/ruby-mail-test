#!/usr/bin/ruby -Ku
# -*- encoding: utf-8 -*-

##############################################
#                                            #
# MailAnalyzer.rb - analyze mailbox          #
#                                            #
# author: Junki OHMURA                       #
# created: 2009/12/28                        #
#                                            #
##############################################

require 'rubygems'
require 'tmail'

def analyzeAvengerLog(_mail)
	attrs = _mail["x-avenger"].to_s.split("; ")
	avenger_log = {}
	attrs.each do |log|
		pair = log.split("=") # split key-value pairs. ex) client-port=24379
		key = pair[0]
		value = pair[1]
		value = "null" if value == nil
		avenger_log[key] = value 
	end

	return avenger_log
end

def getUniqIP(_mbox)
	
end

def main()
	mailPath = ARGV[0]
	if(mailPath == nil)
		print "Usage: ruby MailSpliter.rb <mail path>\n"
		exit()
	end

	#mbox = TMail::UNIXMbox.new(mailPath)
	mbox = TMail::UNIXMbox.new(mailPath,nil,true)
	
	client_ip = []
	pair = {}
	mbox.each_port do |port|
		mail = TMail::Mail.new(port)
		message_id = mail.message_id
		avenger_log = analyzeAvengerLog(mail)
		#puts message_id
		#puts avenger_log["client-ip"]
		if(pair[message_id]!=nil)
			pair[message_id] = pair[message_id] + "\n" + avenger_log["client-ip"]
		else
			pair[message_id] = "\n" + avenger_log["client-ip"]
		end

		client_ip.push(avenger_log["client-ip"])

		#avenger_log.each_pair do |k,v|
		#	puts k + "=>" + v
		#end 
	end
	
	pair.each_pair do |k,v|
		print k 
		print " =>" 
		puts v
	end

	puts ""
	print "client-ip.length=>"
	puts client_ip.length
	print "client-ip.uniq.length=>"
	puts client_ip.uniq.length

end

# run this program
main()

