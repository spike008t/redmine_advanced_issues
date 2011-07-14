
require 'redmine_advanced_issues/time_management'

module Hooks

  class ControllerIssuesEditBeforeSaveHook < Redmine::Hook::ViewListener

    def controller_issues_edit_before_save(context={})

      if context[:params] && context[:params][:issue] && context[:params][:issue][:estimated_hours].present?

        value = context[:params][:issue][:estimated_hours]
        time_unit = ""

        if value.to_s =~ /^([0-9]+)\s*[a-z]{1}$/
          time_unit = RedmineAdvancedIssues::TimeManagement.getUnitTimeFromChar value.to_s[-1, 1]
        else
          time_unit = Setting.plugin_redmine_advanced_issues['default_unit']
        end #if

        if !time_unit.empty?
            context[:issue][:estimated_hours] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
        end #if

      return ''

      end #if

    end #controller_issues_edit_before_save

    alias_method :controller_issues_new_before_save, :controller_issues_edit_before_save

  end #class

end #module

