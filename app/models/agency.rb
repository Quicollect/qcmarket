class Agency < Account
	before_create { add_default_price_models }

	has_many :agency_services, :dependent => :destroy
	has_many :reviews, :dependent => :destroy
	has_many :price_models, :dependent => :destroy
	has_many :agency_contracts, :dependent => :destroy
	has_many :debt_placements
	
	
	accepts_nested_attributes_for :agency_services, :allow_destroy => true
	accepts_nested_attributes_for :price_models, :allow_destroy => true
	accepts_nested_attributes_for :agency_contracts

	def services(symbol)
		agency_services.where(debt_type_id: Debts::Type.lookup(symbol))
	end

	def distance=(distance)
		@distance = distance
	end

	def distance
		@distance
	end

	#
	def avg_rating
		reviews.length > 0 ? reviews.map(&:review_level).inject(0, :+)*1.0/reviews.length : 0
	end

	# between 0 to 1
	def rating_factor
		case reviews.length
			when 0..5
				0.35
			when 6..10
				0.50
			when 11..20
				0.75
			when 21..40
				0.90
			else
				1
		end
	end

	# between 0 to 10
	def score
		reviews.length > 1 ? 5 + (avg_rating-2.5)*2*rating_factor : -1
	end

	def distance_score
		case distance
			when 0..10
				10
			when 10..50
				8
			when 50..100
				5
			when 100..200
				0
			else
				-5
		end
	end

	def current_contract
		contract = AgencyContract.active_contract(self.id)
		if (contract.length > 0)
			contract.last
		elsif (self.new_record?)
			self.agency_contracts.build
		else
			self.agency_contracts.create(content: "")
		end
	end


	# not stored in DB only in memory
  	def selected_price_model=(price_model)
		@selected_price_model = price_model
  	end

	# not stored in DB only in memory
	def selected_price_model
    	@selected_price_model
  	end

  	def add_default_price_models
		models = PriceModel.defaults
		models.each do |m|
			self.price_models << m.dup
		end
	end
end
