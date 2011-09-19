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

require_dependency 'time_entry'

require 'redmine_advanced_issues/time_management'

module RedmineAdvancedIssues
  module Patches
    module TimeEntryPatch
      def self.included(base) # :nodoc:

        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
        end #base.class_eval

      end #self.included(base)

      module ClassMethods
      end #ClassMethods

      module InstanceMethods

        def time
          return RedmineAdvancedIssues::TimeManagement.calculate hours, Setting.plugin_redmine_advanced_issues['default_unit']
        end

        #TODO: refactoring
        def default_unit_time
          case Setting.plugin_redmine_advanced_issues['default_unit']
            when 'hours'
              return l(:hours)
            when 'days'
              return l(:days)
            when 'weeks'
              return l(:weeks)
            when 'months'
              return l(:months)
            when 'years'
              return l(:years)
            else
              return l(:hours)
          end #case
        end #default_unit_time
      end #InstanceMethods
    end #TimeEntryPatch
  end #Patches
end #RedmineAdvancedIssues

