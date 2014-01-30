class AddModifierIdColumnToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :modifier_id, :integer
  end
end
