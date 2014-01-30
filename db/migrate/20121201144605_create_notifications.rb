class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :question_id
      t.integer :user_id
      t.boolean :read
      t.string :type

      t.timestamps
    end
  end
end
