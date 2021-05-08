class CreateUserSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :user_skills do |t|
    	t.references :user, index: true, foreign_key: true
    	t.references :skill, index: true, foreign_key: true
    	t.integer :rating

      t.timestamps
    end
  end
end
