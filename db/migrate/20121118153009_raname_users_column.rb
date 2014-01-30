class RanameUsersColumn < ActiveRecord::Migration
  def change
    rename_column :users, :athena, :email
  end
end
