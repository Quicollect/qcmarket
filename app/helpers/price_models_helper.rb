module PriceModelsHelper
	def cell_info(pm, member, type, postfix="")
		object = pm.object
		cls = "class='no-spinner editable-cell #{'alert-error' if pm.object.errors[member].count > 0}'"
		tooltip = "title=\"#{object.errors[member].join(', ')}\""

		return "#{pm.input member, as: :hidden} <a href='#' #{cls} id='#{member.to_s + object.id.to_s}' #{tooltip} data-type='#{type.to_s}' 
					data-url='' data-title='' #{'readonly' if object.system?}> #{object[member]} </a> #{postfix}
		    	".html_safe
	end

end
