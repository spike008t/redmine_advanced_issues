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

module RedmineAdvancedIssues
  module Patches
    module QueryPatch
      if Rails::VERSION::MAJOR < 3
        def available_columns_with_spent_hours
	  returning available_columns_without_spent_hours do |columns|
	    if (project and User.current.allowed_to?(:view_time_entries, project)) or User.current.admin?
		    
	      columns << QueryColumn.new(:spent_hours, 
			      :caption => :label_spent_hours, 
			      :sortable => "(select sum(hours) from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id)"
			      ) unless columns.detect { |c| c.name == :spent_hours }
			
	      columns << QueryColumn.new(:spent_time, 
			      :caption => :label_spent_time, 
			      :sortable => "(select sum(hours) / #{TimeManagement.getCoef(Setting.plugin_redmine_advanced_issues['default_unit'].to_s)} from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id)"
			      ) unless columns.detect { |c| c.name == :spent_time }

	      columns << QueryColumn.new(:calculated_spent_hours, 
			      :caption => :label_calculated_spent_hours, 
			      :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100))"
			      ) unless columns.detect { |c| c.name == :calculated_spent_hours }

	      columns << QueryColumn.new(:calculated_spent_time, 
			      :caption => :label_calculated_spent_time, 
			      :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100)) / #{TimeManagement.getCoef(Setting.plugin_redmine_advanced_issues['default_unit'].to_s)}"
			      ) unless columns.detect { |c| c.name == :calculated_spent_time }

	      columns << QueryColumn.new(:divergent_hours, 
			      :caption => :label_divergent_hours, 
			      :sortable => "((select sum(hours) from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100))"
			      ) unless columns.detect { |c| c.name == :divergent_hours }


	      columns << QueryColumn.new(:divergent_time, 
			      :caption => :label_divergent_time, 
			      :sortable => "((select sum(hours) / #{TimeManagement.getCoef(Setting.plugin_redmine_advanced_issues['default_unit'].to_s)} from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100s))"
			      ) unless columns.detect { |c| c.name == :divergent_time }

	      columns << QueryColumn.new(:remaining_hours, 
			      :caption => :label_remaining_hours, 
			      :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100))"
			      ) unless columns.detect { |c| c.name == :remaining_hours }

	      columns << QueryColumn.new(:remaining_time, 
			      :caption => :label_remaining_time, 
			      :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100)) / #{TimeManagement.getCoef(Setting.plugin_redmine_advanced_issues['default_unit'].to_s)}"
			      ) unless columns.detect { |c| c.name == :remaining_time }

	    end #if

	  end #returning

        end #def

      else #if VERSION

        def available_columns_with_spent_hours

          available_columns_without_spent_hours.tap do |columns|

	    if (project and User.current.allowed_to?(:view_time_entries, project)) or User.current.admin?
	      columns << QueryColumn.new(:spent_hours, 
			      :caption => :label_spent_hours, 
			      :sortable => "(select sum(hours) from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id)"
			      ) unless columns.detect { |c| c.name == :spent_hours }

	      columns << QueryColumn.new(:spent_time, 
			      :caption => :label_spent_time, 
			      :sortable => "(select sum(hours) / #{TimeManagement.getCoef(Setting.plugin_redmine_advanced_issues['default_unit'].to_s)} from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id)"
			      ) unless columns.detect { |c| c.name == :spent_time }

	      columns << QueryColumn.new(:calculated_spent_hours, 
			      :caption => :label_calculated_spent_hours, 
			      :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100))"
			      ) unless columns.detect { |c| c.name == :calculated_spent_hours }

	      columns << QueryColumn.new(:calculated_spent_time, 
			      :caption => :label_calculated_spent_time, 
			      :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100)) / #{TimeManagement.getCoef(Setting.plugin_redmine_advanced_issues['default_unit'].to_s)}"
			      ) unless columns.detect { |c| c.name == :calculated_spent_time }

	      columns << QueryColumn.new(:divergent_hours, 
			      :caption => :label_divergent_hours, 
			      :sortable => "((select sum(hours) from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100))"
			      ) unless columns.detect { |c| c.name == :divergent_hours }


	      columns << QueryColumn.new(:divergent_time, 
			      :caption => :label_divergent_time, 
			      :sortable => "((select sum(hours) / #{TimeManagement.getCoef(Setting.plugin_redmine_advanced_issues['default_unit'].to_s)} from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100s))"
			      ) unless columns.detect { |c| c.name == :divergent_time }

	      columns << QueryColumn.new(:remaining_hours, 
			      :caption => :label_remaining_hours, 
			      :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100))"
			      ) unless columns.detect { |c| c.name == :remaining_hours }

	      columns << QueryColumn.new(:remaining_time, 
			      :caption => :label_remaining_time, 
			      :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100)) / #{TimeManagement.getCoef(Setting.plugin_redmine_advanced_issues['default_unit'].to_s)}"
			      ) unless columns.detect { |c| c.name == :remaining_time }

	    end #if

	  end #returning

	end #def

      end #if VERSION
	  
      def self.included(klass)
	klass.send :alias_method_chain, :available_columns, :spent_hours
      end

    end #module
  end #module
end #module
