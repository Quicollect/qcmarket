class AgencyService < ActiveRecord::Base
	belongs_to :agency
	belongs_to :debt_type
	belongs_to :debt_segment

	scope :find_by_type_and_segment, lambda {|type, segment| 
		 where(debt_type_id: type, debt_segment_id: segment).limit(1)
		}

	# get agency services attached to the relevant price model and segment
	scope :find_support, lambda { |pm_ids, segment, debt_type_id|
		AgencyService.all.joins("inner join price_models_debt_types 
			on price_models_debt_types.debt_type_id = agency_services.debt_type_id 
			inner join price_models on price_models.id = price_models_debt_types.price_model_id and price_models.agency_id = agency_services.agency_id").
			where(debt_segment_id: segment, debt_type_id: debt_type_id).where("price_models.id in (?)", pm_ids)
	}
end
