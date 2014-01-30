class AddScoreToQuestionsAndAnswers < ActiveRecord::Migration
  def change
    add_column :questions, :score, :integer
  end
end
