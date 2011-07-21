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

        def has_risk?
          (spent_time_over_estimated? || miss_time? || behind_schedule?) && !closed?
        end #has_risk

        def estimated_days
          if !estimated_hours.nil? && !Setting.plugin_redmine_advanced_issues['hours_in_day'].nil?
            return estimated_hours.to_f / Setting.plugin_redmine_advanced_issues['hours_in_day'].to_f
          end #if
        end #estimated_days

        def estimated_time
          return RedmineAdvancedIssues::TimeManagement.calculate estimated_hours, Setting.plugin_redmine_advanced_issues['default_unit']
        end #estimated_time

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
            end
          end #default_unit_time

          def spent_time
            time = spent_hours
            return RedmineAdvancedIssues::TimeManagement.calculate spent_hours, Setting.plugin_redmine_advanced_issues['default_unit']
          end #def
		  
		  def calculated_spent_hours
		    return self_and_descendants.sum("estimated_hours * done_ratio / 100").to_f || 0.0
		  end #calculated_spent_hours
		  
		  def divergent_hours
		    return spent_hours - calculated_spent_hours
		  end #divergent_hours
		  
		  def divergent_time
		    return RedmineAdvancedIssues::TimeManagement.calculate divergent_hours, Setting.plugin_redmine_advanced_issues['default_unit']
		  end #divergent_time
		  
		  def remaining_hours
			return self_and_descendants.sum("estimated_hours - (estimated_hours * done_ratio / 100)").to_f || 0.0
		  end #remaining_hours
		  
		  def remaining_time
		    return RedmineAdvancedIssues::TimeManagement.calculate remaining_hours, Setting.plugin_redmine_advanced_issues['default_unit']
		  end #remaining_time

      end #InstanceMethods

    end #IssuePatch
  end #Patches
end #RedmineAdvancedIssues

