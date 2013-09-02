module Lookup
	include Searchable
<<<<<<< HEAD
	include ActionView::Helpers::UrlHelper
=======
>>>>>>> e74b7e8... first commit to the market place app

	def lookup_name(str)
		lookup_hash(:names)[str.downcase.to_sym]
	end
	
	def lookup(symbol)
		lookup_hash(:names)[symbol].id
	end

	def symbol(id)
		get_name(id).downcase.to_sym
	end

	def get_name(id)
		lookup_hash(:ids)[id].name
	end

<<<<<<< HEAD
	def short_text(id)
		I18n.translate("lookups.#{self.name.demodulize.downcase}.#{self.get_name(id).downcase}.short")
	end

	def long_text(id, account=nil)
		url = eval("Rails.application.routes.url_helpers.#{account.class.name.downcase}_path(account)") if (account)

		I18n.translate("lookups.#{self.name.demodulize.downcase}.#{self.get_name(id).downcase}.long", 
					account: account.nil? ? "" : "#{link_to account.name.upcase, url}").html_safe
	end

=======
>>>>>>> e74b7e8... first commit to the market place app
private
	
	def lookup_hash(symbol)
		if !defined? @hash
			@hash = Rails.cache.read(self.name.to_sym)
			if (@hash.nil?)
				@hash = {}
				@hash[:names] = {}
				@hash[:ids] = {}
				
				all.each do | item |
					@hash[:names][item.name.downcase.to_sym] = item
					@hash[:ids][item.id] = item
				end
				Rails.cache.write(self.name.to_sym, @hash, expires_in: 1.day)
				Rails.logger.info "#{DateTime.now} | QC | lookup #{self.name} was loaded with #{@hash[:ids].length} items" 
			end
		end

		return @hash[symbol]
	end
end
