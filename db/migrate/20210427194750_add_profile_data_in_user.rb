class AddProfileDataInUser < ActiveRecord::Migration[6.1]
  def change
		add_column :users, :short_bio, :string
		add_column :users, :looking_for, :text
		add_column :users, :long_bio, :text
		add_column :users, :experience, :float
		add_column :users, :age, :integer
		add_column :users, :external_link, :string
		add_column :users, :location, :string
  end
end
