class SwitchAgenciesToAccounts < ActiveRecord::Migration
  disable_ddl_transaction!

  def self.up
  	# insert data to accounts
    execute "insert into accounts select id, id,
    		'Agency', name, website, phone, fax, email, address, 
    		notes, country_id, latitude, longitude, gmaps, enabled, 
    		created_at, updated_at from agencies"
  end

  def self.down
	# TODO: need to add moving data from accounts back to agencies

	#execute "delete from accounts"
  end
end
