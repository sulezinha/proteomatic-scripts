# Copyright (c) 2009 Michael Specht
# 
# This file is part of Proteomatic.
# 
# Proteomatic is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Proteomatic is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Proteomatic.  If not, see <http://www.gnu.org/licenses/>.

require 'include/ruby/proteomatic'


class SvgToPng < ProteomaticScript
	def run()
		@input[:svgFiles].each do |ls_InPath|
			command = "rsvg-convert -z #{@param[:zoom]} -o \"#{@output[ls_InPath]}\" \"#{ls_InPath}\""
			system(command)
		end
	end
end

lk_Object = SvgToPng.new