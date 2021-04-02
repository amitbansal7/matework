# frozen_string_literal: true

class AddDeliveredToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :delivered, :boolean, default: false, index: true
  end
end
