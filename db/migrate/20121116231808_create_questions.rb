class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table 'questions' do |t|
      t.text :details
      t.text :title
      t.references :user
      t.references :hashtag
    end
  end

  def self.down
    drop_table 'questions'
  end
end
