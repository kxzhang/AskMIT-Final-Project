class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table 'users' do |t|
      t.string :athena
      t.string :first_name
      t.string :last_name
    end
  end

  def self.down
    drop_table 'users'
  end
end
