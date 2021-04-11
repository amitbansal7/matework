class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
    	t.references :invite, index: true
    	t.text :text
    	t.integer :sender_id, index: true

      t.timestamps
    end
  end
end
