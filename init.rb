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

require 'redmine'
require 'dispatcher'

RAILS_DEFAULT_LOGGER.info 'Starting advenced Issues Plugin for RedMine'

Dispatcher.to_prepare do

  # add time unit conversion
  Issue.send(:include, RedmineAdvancedIssues::Patches::IssuePatch) unless Issue.included_modules.include? RedmineAdvancedIssues::Patches::IssuePatch  
  TimeEntry.send(:include, RedmineAdvancedIssues::Patches::TimeEntryPatch) unless TimeEntry.included_modules.include? RedmineAdvancedIssues::Patches::TimeEntryPatch

  # add spent time column
  Query.send(:include, RedmineAdvancedIssues::Patches::QueryPatch) unless Query.include?(RedmineAdvancedIssues::Patches::QueryPatch)
  QueriesHelper.send(:include, RedmineAdvancedIssues::Patches::QueriesHelperPatch) unless QueriesHelper.include?(RedmineAdvancedIssues::Patches::QueriesHelperPatch)
  
end

Redmine::Plugin.register :redmine_advanced_issues do
  name 'Redmine Advanced Issues plugin'
  author 'Tieu-Philippe KHIM'
  description '
This is a plugin for Redmine, that add some advanced stuffs.
Spent time columns, unit time customize
'
  version '0.0.4'
  url 'http://blog.spikie.info/'
  author_url 'http://blog.spikie.info'

  # Minimum version of Redmine.
  requires_redmine :version_or_higher => '0.9.0'

  settings(:default => {
             'hours_in_day' => '7.4',
             'char_for_day' => 'd',

             'days_in_week' => '5',
             'char_for_week' => 'w',

             'weeks_in_month' => '4',
             'char_for_month' => 'm',

             'months_in_year' => '12',
             'char_for_year' => 'y',

             'default_unit' => 'hours',

           }, :partial => 'settings/advanced_issues_settings')


end

require 'hooks/controller_issues_edit_before_save_hook'
require 'hooks/controller_timelog_edit_before_save_hook'

