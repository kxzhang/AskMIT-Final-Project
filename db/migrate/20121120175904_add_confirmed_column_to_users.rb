class AddConfirmedColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirm, :boolean
  end
end
