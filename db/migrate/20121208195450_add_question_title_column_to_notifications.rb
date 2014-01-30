class AddQuestionTitleColumnToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :question_title, :string
  end
end
