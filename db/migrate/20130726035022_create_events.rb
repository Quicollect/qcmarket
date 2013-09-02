class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
		t.integer :event_type
		t.integer :user_id
		t.integer :account_id # not normalized, for performence
		t.text :text
		t.integer :entity_type
		t.integer :entity_id
		t.boolean :private
      	t.timestamps
    end

    create_table :event_files do |t|
    	t.integer :event_id
    	t.integer :resource_id
    	t.timestamps
    end

    create_table :event_types do |t|
    	t.string :name
    end

    create_table :entity_types do |t|
    	t.string :name
    end

	add_index :events, [:account_id]
	add_index :events, [:entity_type, :entity_id, :created_at]
    add_index :event_files, :event_id
    add_index :event_files, :resource_id
  end
end
