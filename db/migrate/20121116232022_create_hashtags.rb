class CreateHashtags < ActiveRecord::Migration
  def self.up
    create_table 'hashtags' do |t|
      t.string :name
    end
  end

  def self.down
    drop_table 'hashtags'
  end
end
