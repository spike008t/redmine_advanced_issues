# Redmine advanced issues - Plugin improve time entry
# Copyright (C) 2011  Tieu-Philippe Khim
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'redmine_advanced_issues/time_management'

module RedmineAdvancedIssues
  module Patches
    module QueriesHelperPatch
	
	  def column_content_with_spent_hours(column, issue)
	    value = column.value(issue)
		
		if %w(Fixnum Float).include?( value.class.name ) and [:spent_hours, :calculated_spent_hours, :divergent_hours, :remaining_hours].include?(column.name)
			sprintf "%.2f", value
		else #if
		  column_content_without_spent_hours(column, issue)
		end #if
	  end #def
	  
	  def self.included(base)
	    base.send :alias_method_chain, :column_content, :spent_hours
	  end
	
	end
  end
end