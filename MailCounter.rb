#!/usr/bin/ruby -Ku
# -*- encoding: utf-8 -*-

############################################
#                                          #
# MailCounter.rb  - Mail count program     #
#                                          #
# author: Junki OHMURA                     #
# created: 2009/12/16                      #
#                                          #
############################################

require 'rubygems'
require 'tmail'

def main()
	mailPath = ARGV[0]
	if(mailPath == nil)
		print "Usage: ruby MailCounter.rb <mail path>\n"
		exit()
	end

	puts "counting mail " + mailPath + "..."
	# apply rpeadonly access to mailbox
	mbox = TMail::UNIXMbox.new(mailPath, nil, true)
	# readonly false
	#mbox = TMail::UNIXMbox.new($mailPath)

	count = 0
	mbox.each_port do |port|
		mail = TMail::Mail.new(port)
		puts mail.subject
		count += 1
	end
	puts "MailCount: " + String(count)

end

# run this program - MailCount.rb
main()

