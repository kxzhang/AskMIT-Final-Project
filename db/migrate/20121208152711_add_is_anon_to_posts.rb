class AddIsAnonToPosts < ActiveRecord::Migration
  def self.up
  	add_column :questions, :is_anon, :boolean
  	add_column :answers, :is_anon, :boolean
  end

  def self.down
  	remove_column :questions, :is_anon, :boolean
  	remove_column :answers, :is_anon, :boolean
  end
end
