module ApplicationHelper

	def format_date(date_value)
		unless date_value.nil?
			I18n.l(date_value)
		end		

	end
end
