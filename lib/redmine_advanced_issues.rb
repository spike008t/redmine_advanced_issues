require 'redmine_advanced_issues/issue_patch'

module RedmineAdvancedIssues

  def self.has_sub_issues_functionality_active
    ((Redmine::VERSION.to_a <=> [1,0,0]) >= 0)
  end

end

