module CountriesHelper
	@@sprites = nil

	# create all the relevant sprites based on country id
	def image_sprite(cid, options = {}) 		
		@@sprites = Rails.cache.read(:countries_sptire) if @@sprites.nil?
		if (@@sprites.nil?)
			@@sprites = {}
			Country.all.order('initials asc').each_with_index do | c, i |
				column = i.modulo 15
				row = i / 15
				@@sprites[id_to_symbol(c.id)] = {w: 16, h: 12, x: 7+column*39, y: 2+row*23.5} 
			end

			Rails.cache.write(:countries_sptire, @@sprites, expires_in: 1.day)
			Rails.logger.info "#{DateTime.now} | QC | countries was mapped to sprites (#{@@sprites.length} items)"
		end

		if (cid.nil?)
			c = Country.all.last;
		else
			c = Country.find(cid);
		end
		image = id_to_symbol(c.id)
		if (options[:title].nil?)
			options[:title] = c.name
		end
		
		%(<div class="sprite #{options[:class]}" style="display:inline-block;background: url('#{image_path('all-flags-small.gif')}') no-repeat -#{@@sprites[image][:x]}px -#{@@sprites[image][:y]}px; width: #{@@sprites[image][:w]}px; padding-top: #{@@sprites[image][:h]}px; #{options[:style]}" title="#{options[:title]}"></div>).html_safe
	end

private
	def id_to_symbol(id)
		"country#{id.to_s}".to_sym
	end 
end
