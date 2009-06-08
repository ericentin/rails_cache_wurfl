require 'rails_cache_wurfl/wurfl/wurflhandset'
require 'rubygems'
require 'nokogiri'

# Modified to use nokogiri. GREATLY increased speed.
# $Id: wurflloader.rb,v 1.1 2003/11/23 12:26:05 zevblut Exp $
# Authors: Zev Blut (zb@ubit.com)
# Copyright (c) 2003, Ubiquitous Business Technology (http://ubit.com)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#
#    * Neither the name of the WURFL nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

class WurflLoader
  def initialize 
    @handsets = Hash::new
    @fallbacks = Hash::new
  end

  def load_wurfl(wurflfile)
    file = File.new(wurflfile)
    doc = Nokogiri::XML::Document.parse file

    # read counter
    rcount = 0

    # iterate over all of the devices in the file
    doc.xpath("wurfl/devices/device").each do |element| 

      rcount += 1
      hands = nil # the reference to the current handset
      if element.attributes["id"].to_s == "generic"
        # setup the generic Handset 

        if @handsets.key?("generic") then
          hands = @handsets["generic"]
          puts "Updating the generic handset at count #{rcount}" if @verbose	
        else
          # the generic handset has not been created.  Make it
          hands = WurflHandset::new "generic","generic"
          @handsets["generic"] = hands
          @fallbacks["generic"] = Array::new
          puts "Made the generic handset at count #{rcount}" if @verbose	
        end

      else
        # Setup an actual handset

        # check if handset already exists.
        wurflid = element.attributes["id"].to_s	
        if @handsets.key?(wurflid)
          # Must have been created by someone who named it as a fallback earlier.
          hands = @handsets[wurflid]
        else
          hands = WurflHandset::new "",""
        end
        hands.wurfl_id = wurflid
        hands.user_agent = element.attributes["user_agent"].to_s

        # get the fallback and copy it's values into this handset's hashtable
        fallb = element.attributes["fall_back"].to_s

        # for tracking of who has fallbacks
        if !@fallbacks.key?(fallb)
          @fallbacks[fallb] = Array::new   
        end
        @fallbacks[fallb]<< hands.user_agent

        # Now set the handset to the proper fallback reference
        if !@handsets.key?(fallb)
          # We have a fallback that does not exist yet, create the reference.
          @handsets[fallb] = WurflHandset::new "",""
        end
        hands.fallback = @handsets[fallb]
      end

      # now copy this handset's specific capabilities into it's hashtable
      element.xpath("./*/capability").each do |el2|
        hands[el2.attributes["name"].to_s] = el2.attributes["value"].to_s
      end
      @handsets[hands.wurfl_id] = hands

      # Do some error checking
      if hands.wurfl_id.nil? 
        puts "a handset with a nil id at #{rcount}" 
      elsif hands.user_agent.nil? 
        puts "a handset with a nil agent at #{rcount}"
      end           
    end
    return @handsets, @fallbacks
  end

end