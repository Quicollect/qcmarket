class Account < ActiveRecord::Base
	self.inheritance_column = 'accountable_type'
	
	validates :name, presence: true # if it is put on the account level it is called twice for some reason
	validates_format_of :email, allow_blank: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	belongs_to :country
	has_many :resources, :dependent => :destroy
	has_many :users, :dependent => :destroy

	include Addressable
	extend Searchable

	acts_as_gmappable :validation => false
	geocoded_by :full_street_address   # can also be an IP address

	def distance=(distance)
		@distance = distance
	end

	def distance
		@distance
	end


	def self.account_types 
		['Agency', 'Creditor'] # TODO: move to conf / DB
	end

  	def thumbnail
  		logo_resource_id? ? Document.find(logo_resource_id).resource.url(:medium) : "no-image-available.png"
  	end

  	# TODO: take the UI/View elemnts from the model
	def gmaps4rails_title
      "#{self.name}" 
    end

    def gmaps4rails_address
 		full_address
	end

	def gmaps4rails_infowindow
      	"<h4><a href='/#{ActiveSupport::Inflector.pluralize(accountable_type.downcase)}/#{self.id}'>#{self.name}</a></h4>#{self.address}" 
    end

	def gmaps4rails_marker_picture
		picture = picture_json("blue")
	end
end
