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

  class TimeManagement

	##
	# Return the coef to apply to get the good value
	##
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
  
	##
	# Calculate the good value for the specified time unit
	##
    def TimeManagement.calculate(value, unit_time)
	
	  return nil if value.nil?

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

	  return nil if value.nil?

      value = value.to_f

      return value if unit_time == 'hours'

      value = value * Setting.plugin_redmine_advanced_issues['months_in_year'].to_f if unit_time == 'years'

      value = value * Setting.plugin_redmine_advanced_issues['weeks_in_month'].to_f if unit_time == 'years' || unit_time == 'months'

      value = value * Setting.plugin_redmine_advanced_issues['days_in_week'].to_f if unit_time == 'years' || unit_time == 'months' || unit_time == 'weeks'

      value = value * Setting.plugin_redmine_advanced_issues['hours_in_day'].to_f if unit_time == 'years' || unit_time == 'months' || unit_time == 'weeks' || unit_time == 'days'

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
	
	def TimeManagement.getCharFromTimeUnit(unit)
	  case unit
		when 'days'
			return Setting.plugin_redmine_advanced_issues['char_for_day']
		when 'weeks'
			return Setting.plugin_redmine_advanced_issues['char_for_week']
		when 'months'
			return Setting.plugin_redmine_advanced_issues['char_for_month']
		when 'years'
			return Setting.plugin_redmine_advanced_issues['char_for_year']
	  end #case
	  return '';
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
