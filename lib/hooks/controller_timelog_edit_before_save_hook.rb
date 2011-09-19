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

require 'logger'

require 'redmine_advanced_issues/time_management'

module Hooks

  class ControllerTimelogEditBeforeSaveHook < Redmine::Hook::ViewListener

    def logger
      RAILS_DEFAULT_LOGGER
    end

    def controller_timelog_edit_before_save(context={})

      if context[:params] && context[:params][:time_entry] && context[:params][:time_entry][:hours].present?

        value = context[:params][:time_entry][:hours]
        time_unit = ""

        if value.to_s =~ /^([0-9]+)\s*[a-z]{1}$/
          time_unit = RedmineAdvancedIssues::TimeManagement.getUnitTimeFromChar value.to_s[-1, 1]
        else
          time_unit = Setting.plugin_redmine_advanced_issues['default_unit']
        end #if

        if !time_unit.empty?
            context[:time_entry][:hours] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
        end #if

      return ''

      end #if

    end #controller_timelog_edit_before_save

    alias_method :controller_timelog_new_before_save, :controller_timelog_edit_before_save

  end #class

end #module

