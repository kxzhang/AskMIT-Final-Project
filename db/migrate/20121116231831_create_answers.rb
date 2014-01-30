class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table 'answers' do |t|
      t.text :content
      t.references :user
      t.references :question
    end
  end

  def self.down
    drop_table 'answers'
  end
end
