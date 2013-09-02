class ChangeStringToTextInModels < ActiveRecord::Migration
  def change
  	change_column :price_models, :description, :text
  	change_column :debts, :description, :text
  	change_column :accounts, :notes, :text
  	change_column :reviews, :description, :text
  end
end
