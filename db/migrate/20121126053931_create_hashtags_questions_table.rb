class CreateHashtagsQuestionsTable < ActiveRecord::Migration
  def up
  	create_table :hashtags_questions, :id => false do |t|
  		t.integer :hashtag_id
  		t.integer :question_id
  	end
  end

  def down
  	drop_table :hashtags_questions
  end
end
