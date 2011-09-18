
module RedmineAdvancedIssues

  class TimeManagement

	def TimeManagement.getCoef(unit_time)
	  
	  coef = 1.0;
	  
	  return coef.to_f if unit_time.nil? || unit_time == 'hours'
	  
	  coef = coef / Setting.plugin_redmine_advanced_issues['hours_in_day'].to_f
	  return coef.to_f if unit_time == 'days'
	  
	  coef = coef / Setting.plugin_redmine_advanced_issues['days_in_week'].to_f
	  return coef.to_f if unit_time == 'weeks'
	  
	  coef = coef / Setting.plugin_redmine_advanced_issues['weeks_in_month'].to_f
	  return coef.to_f if unit_time == 'months'
	  
	  coef = coef / Setting.plugin_redmine_advanced_issues['months_in_year'].to_f
	  return coef.to_f if unit_time == 'years'
	  
	  return coef.to_f
	  
	end #getCoef
  
    def TimeManagement.calculate(value, unit_time)

      value = value.to_f
      unit_time = Setting.plugin_redmine_advanced_issues['default_unit'].to_s

      return "%.2f" % value if unit_time.nil? || unit_time == 'hours'

      value = value / Setting.plugin_redmine_advanced_issues['hours_in_day'].to_f
      return "%.2f" % value if unit_time == 'days'

      value = value / Setting.plugin_redmine_advanced_issues['days_in_week'].to_f
      return "%.2f" % value if unit_time == 'weeks'

      value = value / Setting.plugin_redmine_advanced_issues['weeks_in_month'].to_f
      return "%.2f" % value if unit_time == 'months'

      value = value / Setting.plugin_redmine_advanced_issues['months_in_year'].to_f

      return "%.2f" % value if unit_time == 'years'

      return hours.to_f

    end #calculate

    def TimeManagement.calculateHours(value, unit_time)

		if value.nil?
			return nil
		end

      value = value.to_f

      return value if unit_time == 'hours'

      value = value * Setting.plugin_redmine_advanced_issues['months_in_year'].to_f if unit_time == 'years'

      value = value * Setting.plugin_redmine_advanced_issues['weeks_in_month'].to_f if unit_time == 'years' || unit_time == 'months'

      value = value * Setting.plugin_redmine_advanced_issues['days_in_week'].to_f if unit_time == 'years' || unit_time == 'months' || unit_time == 'weeks'

      value = value * Setting.plugin_redmine_advanced_issues['hours_in_day'].to_f if unit_time == 'years' || unit_time == 'months' || unit_time == 'weeks' || unit_time == 'days'

      #if unit_time == 'days' || unit_time == 'weeks' || unit_time == 'months' || unit_time == 'years'
        #if unit_time == 'weeks' || unit_time == 'months' || unit_time == 'years'
         # if unit_time == 'months' || unit_time == 'years'
          #  if unit_time == 'years'
            #  value = value * Setting.plugin_redmine_advanced_issues['months_in_year'].to_f
           # end #years
             # value = value * Setting.plugin_redmine_advanced_issues['weeks_in_month'].to_f
          #end #months
              #value = value * Setting.plugin_redmine_advanced_issues['days_in_week'].to_f
        #end #weeks
              #value = value * Setting.plugin_redmine_advanced_issues['hours_in_day'].to_f
      #end #days

      return value.to_f
    end #def

    def TimeManagement.getUnitTimeFromChar(char)
      case char
        when Setting.plugin_redmine_advanced_issues['char_for_day']
          return 'days'
        when Setting.plugin_redmine_advanced_issues['char_for_week']
          return 'weeks'
        when Setting.plugin_redmine_advanced_issues['char_for_month']
          return 'months'
        when Setting.plugin_redmine_advanced_issues['char_for_year']
          return 'years'
        else
          return ''
      end #case
    end #def

	def TimeManagement.getDefaultTimeUnit(unit)
		case unit
		when 'days'
		  return I18n.t(:days)
		when 'weeks'
		  return I18n.t(:weeks)
		when 'months'
		  return I18n.t(:months)
		when 'years'
		  return I18n.t(:years)
		end
		return I18n.t(:hours)
	end #def 
	
  end #class

end #module
