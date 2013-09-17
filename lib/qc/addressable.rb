require 'open-uri'
require 'uri'


module Addressable
	BASE_GEO_URL = 'http://maps.googleapis.com/maps/api/geocode/json?address='

	def get_distance_text(obj)
		distance = self.distance_to(obj)
		distance ? distance.round(2) : 'Unknown';
	end

    def picture_json(color)
    	picture = "http://www.google.com/intl/en_us/mapfiles/ms/micons/#{color}-dot.png"
		{
		   "picture" => picture,
		   "width" => 32,
		}
    end

	def full_address_changed?
		address_changed? || city_changed? || zipcode_changed? || state_id_changed? || country_id_changed?
	end


  	def full_address
		addr = "#{address} #{city}".strip
		"#{addr}#{format_address_part(State.get_name(state_id), addr.blank? ? '' : ',')}#{format_address_part(zipcode, ',')}#{format_address_part(Country.get_name(country_id), ',')}".strip
  	end

	def resolve_address
		# we reset the previous fields
		self.latitude = self.longitude = nil
		#self.country_id = Country.find_by_name("Unknown").id

		# resolve using google API
		begin
			if (!self.full_address || full_address.empty?)
				raise "address was not provided"
			end

			url = URI.escape("#{BASE_GEO_URL}#{self.full_address}&sensor=false")
			response = ""
			if (Rails.application.config.proxy)
				curl = Curl::Easy.new(url)
				curl.proxy_url = Rails.application.config.proxy
				curl.proxypwd = Rails.application.config.proxy_usrpwd
				curl.proxy_auth_types = 0 # digest
				curl.perform
				response = curl.body_str
			else
				response = open(url).read
			end

			json = JSON.parse(response)
			
			if (json["status"] == "OK")
				Rails.logger.warn "QC | found #{json["results"].length} matching resolutions (using first)" if json["results"].length > 1
				self.latitude = json["results"][0]["geometry"]["location"]["lat"].to_f
				self.longitude = json["results"][0]["geometry"]["location"]["lng"].to_f	

				# set country
				set_data(json["results"][0])
			else
				raise json["status"]
			end
		rescue => msg
			Rails.logger.warn "QC | Unable to determine location for address '#{self.full_address}': #{msg}"
		end
		
		return [self.latitude, self.longitude]
	end
private
	def format_address_part(val, prefix)
		val.blank? ? "" : "#{prefix} #{val}".strip
	end
	
	def set_data (result)
		result["address_components"].each do | a |
			if (a["types"] && a["types"][0] == "country")
				Rails.logger.info "QC | resolved to country '#{a["long_name"]}'"
				c = Country.lookup_name(a["long_name"])
				self.country_id = c.id if c > 0
			elsif (a["types"] && a["types"][0] == "administrative_area_level_1")
				Rails.logger.info "QC | resolved to state '#{a["long_name"]}'"
				s = State.lookup_name(a["long_name"])
				self.state_id = s.id if s > 0
			elsif (a["types"] && a["types"][0] == "postal_code")
				Rails.logger.info "QC | resolved to zipcode '#{a["long_name"]}'"
				self.zipcode = a["long_name"] if a["long_name"].length > 0
			end
		end
	end

end