class AddScoreToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :score, :integer
  end
end
