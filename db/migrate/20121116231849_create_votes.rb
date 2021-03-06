class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table 'votes' do |t|
      t.integer :score
      t.references :user
      t.references :question
      t.references :answer
    end
  end

  def self.down
    drop_table 'votes'
  end
end
