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

