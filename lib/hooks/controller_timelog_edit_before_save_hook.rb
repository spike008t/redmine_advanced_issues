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

