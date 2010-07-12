##
## config.rb
## Login : <elthariel@rincevent>
## Started on  Mon Mar 22 00:25:40 2010 elthariel
## $Id$
##
## Author(s):
##  - elthariel <elthariel@gmail.com>
##
## Copyright (C) 2010 elthariel
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

require 'singleton'
require 'fileutils'
require 'yaml'

require 'settings_kiara'

#
# Settings persistence and default facility
# TODO handle settings file version
# TODO merge loaded settings with defaults
#

class Settings
  include Singleton
  include SettingsKiara

  def self.i
    self.instance
  end

  def init(ui, engine)
    @ui = ui
    @engine = engine

    defaults
    if !File.exists? @cfg_path
      save
    end
    load
  end

  def initialize()
    @cfg_path = ENV['HOME'] + '/.kiara/settings.yaml'
    @data = Hash.new
  end

  def defaults
    @data['midi_out'] = 0
  end

  def save
    if !File.directory? ENV['HOME'] + '/.kiara'
      FileUtils.mkdir ENV['HOME'] + '/.kiara'
    end
    serialized_data = @data.to_yaml
    f = File.new(@cfg_path, "w")
    f.write(serialized_data)
    f.close
  end

  def load
    if File.readable? @cfg_path
      loaded = YAML.load_file(@cfg_path)
      @data.merge! loaded
    end
    apply
  end

  def method_missing(sym, *args)
    if (sym.to_s =~ /=\Z/)
      var_name = sym.to_s.gsub('=','')
      @data[var_name] = args[0]
    else
      @data[sym.to_s]
    end
  end
end
