class PriceModel < ActiveRecord::Base
	belongs_to :agency
	has_and_belongs_to_many :debt_type, class_name: "Debts::Type", :join_table => 'price_models_debt_types'
	accepts_nested_attributes_for :debt_type

	monetize :min_amount_cents, allow_nil: false, :numericality => {
	    :greater_than_or_equal_to => 0
	  }

	monetize :max_amount_cents, allow_nil: false, :numericality => {
    	:greater_than => :min_amount
  	}

	validates :name, presence: true
	validates :min_age, presence: true, numericality: { :greater_than_or_equal_to => 0 } 
	validates :max_age, presence: true, numericality: { :greater_than => :min_age } 
	validates :fee_precentage, presence: true, numericality: { :greater_than => 0, :less_than_or_equal_to => 100 } 

	def age_range
		"#{min_age} - #{max_age}"
	end

	def amount_range
		"#{min_amount} - #{max_amount}"
	end

	scope :defaults, lambda { 
		 where('agency_id is ?', nil)
		}

    def agency_services
		self.debt_type
    end

    scope :find_by_agency, lambda {| debt, agency_id |
		amount = debt.amount.as_us_dollar.amount
		debt_type_id = debt.debt_type_id
		age = (DateTime.now - debt.charge_date).floor
		PriceModel.joins("inner join price_models_debt_types on price_models.id = price_models_debt_types.price_model_id 
    		and price_models_debt_types.debt_type_id = #{debt_type_id}
    		inner join debt_types on price_models_debt_types.debt_type_id= debt_types.id").
    		where("price_models.agency_id = #{agency_id} 
    				and price_models.min_age <= #{age} and price_models.max_age >= #{age}
    				and price_models.min_amount_cents <= #{amount} and price_models.max_amount_cents >= #{amount}
    				and price_models.enabled = ?", true)
    }

    scope :find_match, lambda { |country_id, debt_type_id, amount, age|
    	amount = amount.as_us_dollar.amount
    	country_block = country_id.nil? ? "" : "country_id = #{country_id} and" 
    	PriceModel.joins("inner join price_models_debt_types on price_models.id = price_models_debt_types.price_model_id 
    		and price_models_debt_types.debt_type_id = #{debt_type_id}
    		inner join debt_types on price_models_debt_types.debt_type_id= debt_types.id 
    		inner join accounts on accounts.id = price_models.agency_id").
    		where("#{country_block} accounts.enabled = ? 
    				and price_models.min_age <= #{age} and price_models.max_age >= #{age}
    				and price_models.min_amount_cents <= #{amount} and price_models.max_amount_cents >= #{amount}
    				and price_models.enabled = ?", true, true)
    }
end
