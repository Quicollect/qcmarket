class CountriesController < ApplicationController
	
	def index
	    items(Country)
  	end

	def states
		items(State, "country_id = #{params[:id]}")
	end

private 
	def items(clazz, filter = nil)
		per_page = params[:per_page] ? params[:per_page].to_i : -1
			
		filtered_items = filter ? clazz.where(filter) : clazz.all
	    filtered_items = filtered_items.order("name asc").search(params[:search])
		
		if (params[:per_page])
			@items = filtered_items.paginate(per_page: per_page, page: params[:page])
		else
			@items = filtered_items.paginate(per_page: 10000, page: 1)
		end

	    render "countries/#{clazz.name.pluralize.downcase}.json"
	end
end