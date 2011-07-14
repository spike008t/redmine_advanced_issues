module RedmineAdvancedIssues
  module Patches
    module QueriesHelperPatch
	
	  def column_content_with_spent_hours(column, issue)
	    value = column.value(issue)
		if %w(Fixnum Float).include?( value.class.name ) and [:spent_hours, :calculated_spent_hours, :divergent_hours, :remaining_hours].include?(column.name)
		  sprintf "%.2f", value
		else #if
		  column_content_without_spent_hours(column, issue)
		end #if
	  end #def
	  
	  def self.included(klass)
	    klass.send :alias_method_chain, :column_content, :spent_hours
	  end
	
	end
  end
end