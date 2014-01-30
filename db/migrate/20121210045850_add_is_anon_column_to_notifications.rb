class AddIsAnonColumnToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :is_anon, :boolean
  end
end
