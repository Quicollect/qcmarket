class Review < ActiveRecord::Base
  belongs_to :agency
  belongs_to :debt_placement, class_name: "Debts::Placement"

  validates :review_level, presence: true, numericality: { :greater_than => 0, :less_than_or_equal_to => 5 } 
  validates :service_level, presence: true, numericality: { :greater_than => 0, :less_than_or_equal_to => 5 } 
  validates :aggresive_level, presence: true, numericality: { :greater_than => 0, :less_than_or_equal_to => 5 } 
  validates :speed_level, presence: true, numericality: { :greater_than => 0, :less_than_or_equal_to => 5 } 

end
