#!/usr/bin/ruby -Ku
# -*- encoding: utf-8 -*-

##############################################
#                                            #
# ReconstructMbox rb - remove duplicate mail #
#                                            #
# author: Junki OHMURA                       #
# created: 2009/12/27                        #
#                                            #
##############################################

require 'rubygems'
require 'tmail'
require 'ftools'
# Because of 'TMail::UNIXMbox.create_from_line' bug, override UNIXMbox.
# Ref: http://subtech.g.hatena.ne.jp/secondlife/20080625/1214388941
module TMail
  module TextUtils
    module_function :time2str
  end

  class UNIXMbox
    def UNIXMbox.create_from_line( port )
			#* before *#
      #sprintf 'From %s %s',
      #        fromaddr(), TextUtils.time2str(File.mtime(port.filename))

      #* after (bug fix) *#
      sprintf 'From %s %s',
              fromaddr(port), TextUtils::time2str(File.mtime(port.filename))
    end
  end
end

def main()
	mailPath = ARGV[0]
	if(mailPath == nil)
		print "Usage: ruby MailSpliter.rb <mail path>\n"
		exit()
	end

	include TMail
	mbox = UNIXMbox.new(mailPath)
	m_id_array = []
	total_ct = 0
	remove_ct = 0
	mbox.each_port do |port|
		begin
			total_ct += 1
			mail = Mail.new(port)
			message_id = mail.message_id
			if(m_id_array.include?(message_id)) # duplicat message
				#puts "del"
				port.remove
				remove_ct += 1
			else # unique message
				#puts "keep"
				m_id_array.push(message_id)
				port.move_to mbox.new_port
			end
		rescue Exception
			puts "exception occured"
			m_id_array.push(mail.message_id)
			port.move_to mbox.new_port
		end
	end
	puts "*** Total Mail Count ***"
	puts "[Before] " + total_ct.to_s
	puts "[After]  " + (total_ct - remove_ct).to_s
end

# run this progra
main()

