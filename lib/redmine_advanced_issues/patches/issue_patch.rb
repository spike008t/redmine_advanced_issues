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

require_dependency 'issue'

require 'redmine_advanced_issues/time_management'

module RedmineAdvancedIssues
  module Patches
    module IssuePatch
      def self.included(base) # :nodoc:

        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
		  alias_method_chain :css_classes, :more_css
		  #alias_method_chain :save_issue_with_child_records, :time_entry_record
        end #base.class_eval

      end #self.include(base)

      module ClassMethods
      end #ClassMethods

      module InstanceMethods
		
		# return how many hours has consume over the estimated_hours
		def spent_time_over_estimated
			if spent_time_over_estimated?
				return spent_hours - estimated_hours
			end
			return nil
		end #spent_time_over_estimated
		
        # if spent time > estimated time (over consume)
        def spent_time_over_estimated?
          !spent_hours.nil? && !estimated_hours.nil? && spent_hours > estimated_hours
        end #spent_time_over_estimated?

		# if the issue has some risk for an overdue
        def has_risk?
          (spent_time_over_estimated? || miss_time? || behind_schedule?) && !closed?
        end #has_risk
		
		# khim: Returns true if the issue will be late...
		# khim: ((time_estimated - worked_time) / 7.5) > due_date - Date.today
		def miss_time?
		  !due_date.nil? && ((estimated_hours.to_f - spent_hours.to_f) / Setting.plugin_redmine_advanced_issues['hours_in_day'].to_f) > (due_date - Date.today)
		end

        def estimated_days
          if !estimated_hours.nil? && !Setting.plugin_redmine_advanced_issues['hours_in_day'].nil?
            return estimated_hours.to_f / Setting.plugin_redmine_advanced_issues['hours_in_day'].to_f
          end #if
        end #estimated_days

        def estimated_time
		  time = RedmineAdvancedIssues::TimeManagement.calculate estimated_hours, Setting.plugin_redmine_advanced_issues['default_unit']
		  return nil if time.nil?
		  return time.to_f
          #return sprintf "%.2f %c", time.to_f, default_unit_time
        end #estimated_time

        def default_unit_time
		  return RedmineAdvancedIssues::TimeManagement.getDefaultTimeUnit(Setting.plugin_redmine_advanced_issues['default_unit'])
        end #default_unit_time

        def spent_time
          hours = spent_hours
		  return nil if hours.nil?
          time = RedmineAdvancedIssues::TimeManagement.calculate hours, Setting.plugin_redmine_advanced_issues['default_unit']
		  return time.to_f
		  #return sprintf "%.2f %c", time.to_f, default_unit_time
        end #def
		  
		  def calculated_spent_hours
		    return self_and_descendants.sum("estimated_hours * done_ratio / 100").to_f || 0.0
		  end #calculated_spent_hours
		  
		  def calculated_spent_time
		    time = RedmineAdvancedIssues::TimeManagement.calculate calculated_spent_hours, Setting.plugin_redmine_advanced_issues['default_unit']
		    return nil if time.nil?
			return time.to_f
            #return sprintf "%.2f %c", time.to_f, default_unit_time
		  end #calculated_spent_time
		  
		  def divergent_hours
		    return spent_hours - calculated_spent_hours
		  end #divergent_hours
		  
		  def divergent_time
		    time = RedmineAdvancedIssues::TimeManagement.calculate divergent_hours, Setting.plugin_redmine_advanced_issues['default_unit']
			return nil if time.nil?
			return time.to_f
			#return sprintf "%.2f %c", time.to_f, default_unit_time
		  end #divergent_time
		  
		  def remaining_hours
			return self_and_descendants.sum("estimated_hours - (estimated_hours * done_ratio / 100)").to_f || 0.0
		  end #remaining_hours
		  
		  def remaining_time
		    time = RedmineAdvancedIssues::TimeManagement.calculate remaining_hours, Setting.plugin_redmine_advanced_issues['default_unit']
			return nil if time.nil?
			return time.to_f
			#return sprintf "%.2f %c", time.to_f, default_unit_time
		  end #remaining_time

		  def css_classes_with_more_css
			s = css_classes_without_more_css
			s << ' risk' if has_risk?
			s << ' miss_time' if miss_time?
			s << ' over_estimated' if spent_time_over_estimated?
			return s
		  end #css_classes
		  
		  ## 
		  # 
		  ##
		  def save_issue_with_child_records_with_time_entry_record(params, existing_time_entry=nil)
			if params[:time_entry] && params[:time_entry][:hours].present?
			  params[:time_entry][:hours] = RedmineAdvancedIssues::TimeManagement.calculate params[:time_entry][:hours], Setting.plugin_redmine_advanced_issues['default_unit']
			end
			save_issue_with_child_records_without_time_entry_record(params, existing_time_entry)
		  end #save_issue_with_child_records_with_time_entry_record
		  
      end #InstanceMethods

    end #IssuePatch
  end #Patches
end #RedmineAdvancedIssues

