module ApplicationHelper

	def current_account
		account |=  Account.find(current_user.account_id)
	end

	def current_account?
		account == current_account
	end

	# Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "Quicollect"
		if page_title.empty?
		  base_title
		else
		  "#{base_title} | #{page_title}"
		end
	end
	
	def url_for_ex(resource)
		name = resource.class.name.demodulize.downcase
		resource.new_record? ? eval("#{name.pluralize}_path") : eval("#{name}_path(resource)")
	end

	def time_ago_in_words_ex(date)
		(date.nil? ? t('na') : t('time_ago', time: time_ago_in_words(date))).html_safe
	end

	def days_ago_in_words(date)
	  days = ((Time.now - date.to_time) / 86400.0).round
	  I18n.t :x_days, :count => days, :scope => :'datetime.distance_in_words'
	end

	def sortable(column, model=nil, text=nil)
	    title = model.nil? ? text : I18n.t("activerecord.attributes.#{model.to_s.underscore}.#{column}")
	    css_class = (column == sort_column) ? "current #{sort_direction}" : ""
	    icon_class = (column == sort_column) ? ( sort_direction == "asc" ? "icon-sort-up" : "icon-sort-down" ) : "icon-sort"
	    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"

	    link_to "<i style='padding-right: 5px;' class='#{icon_class}'></i> #{title}".html_safe, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class + " no-spinner"}
  	end


  	def generate_tab(name, resource, members = [], options = {})		
		errors = error_count(resource, members)
		error_str = errors > 0 ? 
				"<span class='badge fix badge-primary #{resource.new_record? ? 'error-overlay-wiz': 'error-overlay'}'>#{errors}</span>"  :
				""
		
		id_str = "id='#{options[:id]}'" if options[:id]
		if (resource.new_record?)
			"<li #{id_str} class='#{'no-padding'} #{options[:class]}'>
				#{error_str}
				<a class='no-spinner' href='##{name}' data-toggle='tab'>#{options[:index]}</a>
			</li>".html_safe
		else
			"<li #{id_str} class='#{options[:class]}'> 
	          <a href='##{name}' class='glyphicons #{options[:icon]} no-spinner' data-toggle='tab'>
	         #{error_str}
	          <i></i>
	          <span class='strong'>#{options[:title]}</span><span>#{options[:details]}</span></a>
	        </li>".html_safe
		end
	end

	def error_count(resource, members)
		errors = 0
		members.each do | member | 
			errors += resource.errors[member].count
		end

		return errors
	end

	def has_more(paginated)
		paginated.per_page * paginated.current_page.to_i < paginated.total_entries
	end
end
