module Debts
	class Debt < ActiveRecord::Base
		acts_as_gmappable :validation => false

		monetize :amount_cents, with_model_currency: :amount_currency
		monetize :amount_paid_cents, with_model_currency: :amount_paid_currency
		
		validates :title, presence: true
	  	validates :amount, presence: true, numericality: { :greater_than => 0 } 
	  	validates :charge_date, presence: true
		validates_format_of :email, allow_blank: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

		has_one :debt_status
		belongs_to :country
		has_many :debt_placements, class_name: "Debts::DebtPlacement", autosave: true
		has_many :debt_payments
		has_many :debt_files
		has_many :resources, through: :debt_files

		# change 1 to what is loaded from the lookups
		has_many :events, -> {where entity_type: 1}, class_name: 'Timeline::Event', foreign_key: :entity_id, :dependent => :destroy

		# TODO: add validation on the debt_status changes	

		accepts_nested_attributes_for :debt_files, :allow_destroy => true
		
		include Addressable

		geocoded_by :full_street_address   # can also be an IP address
		after_validation :geocode          # auto-fetch coordinates

		before_save :pre_save_updates
		before_create :populate_defaults 

		def self.get_not_updated_since(user,date)
			self.viewable_debts(user).where("debts.updated_at < :date", date: date)
				.where("debt_status_id != :status", status: Debts::DebtStatus.lookup(:closed)).order('debts.updated_at asc')
		end


		def self.viewable_debts(user)
	      if (user.is_admin?)
	        Debts::Debt.all
	      elsif (!user.is_agency?)
	        Debts::Debt.where(account_id: user.account_id, deleted: false )
	      else
	        account_id = user.account_id;
	        Debts::Debt.includes(:debt_placements).
	          where("account_id = #{account_id} or debt_placements.agency_id = #{account_id}").
	          where(deleted: false).
	          references(:debt_placements)
	      end
	    end


		def allowed_actions
			# TODO: move to a static (cached) map
			actions = []
			if !new_record?
				if is_status? :draft
					actions = [:assigned, :deleted]
				elsif is_status? :assigned
					actions = [:accepted , :rejected, :inforequired]
				elsif is_status? :rejected
					actions =  [:assigned, :deleted]
				elsif is_status? :accepted
					actions =  [:rejected , :resolved, :inforequired]
				elsif is_status? :inforequired
					actions =  [:assigned]
				elsif is_status? :resolved
					actions =  [:assigned, :closed]
				elsif is_status? :closed
					actions =  [:assigned]
				end
			end

			actions
		end

		def current_active_placement
			debt_placements.last if is_active_placement?
		end

		def is_active_placement?
			debt_placements.length > 0 && debt_placements.last.active
		end

		# note that using "last" will fail the autosave of the nested attribute
		def last_placement
			self.debt_placements[self.debt_placements.length-1]
		end

		def current_assigned_agency
			agency = nil
			placement = self.debt_placements.last
			agency = Agency.find(placement.agency_id) if (placement)
			agency
		end

		def deletable?
			allowed_actions.include? :deleted
		end


		def full_street_address
			address
		end

		# TODO: change title in DB to name
		def name
			title
		end

		def amount_changed?
			amount_cents_changed? || amount_currency_changed?
		end

		def amount_was
			Money.new(amount_cents_was, amount_currency_was)
		end

		def age
			(DateTime.now - charge_date).to_i
		end

		def status=(symbol)
			self.debt_status_id = Debts::DebtStatus.lookup(symbol)
		end

		def self.search(search)
		    if search
		      where('lower(title) LIKE ?', "%#{search.downcase}%")
		    else
		      all
		    end
	  	end

	  	def gmaps4rails_address
	 		"#{self.address}" 
		end

		def gmaps4rails_infowindow
			"<h4><a href='/debts/#{self.id}'>#{self.title}</a></h4>#{self.address}" 
	    end

	    def gmaps4rails_title
	      "#{self.title} (Debt)" 
	    end

		def gmaps4rails_marker_picture
			picture = "http://www.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png"
			{
			   "picture" => picture,
			   "width" => 32,
			}
		end

private
		def is_status?(symbol)
			symbol == Debts::DebtStatus.symbol(self.debt_status_id)
		end

		def pre_save_updates
			# paid currency must be equal to the debt currency
			self.amount_paid = Money.new(amount_paid_cents, amount_currency)
			
			# update current placement various fields if needed
			new_debt_status = Debts::DebtStatus.symbol(self.debt_status_id)
			self.last_placement.accepted_at = DateTime.now if new_debt_status == :accepted && !self.last_placement.accepted_at
			self.last_placement.resolved_at = DateTime.now if new_debt_status == :resolved && !self.last_placement.resolved_at
		end

		def populate_defaults
			self.debt_status_id = Debts::DebtStatus.lookup(:draft) if !self.debt_status_id
		end
	end
end