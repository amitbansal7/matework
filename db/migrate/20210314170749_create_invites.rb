class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
    	t.references :to_user, index: true, foreign_key: {to_table: :users}
    	t.references :from_user, index: true, foreign_key: {to_table: :users}
    	t.string :message
    	t.boolean :accepted, index: true, default: false
    	t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
