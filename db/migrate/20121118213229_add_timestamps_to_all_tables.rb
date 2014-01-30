class AddTimestampsToAllTables < ActiveRecord::Migration
  def change
  	add_column(:answers, :created_at, :datetime)
    add_column(:answers, :updated_at, :datetime)

    add_column(:questions, :created_at, :datetime)
    add_column(:questions, :updated_at, :datetime)

    add_column(:users, :created_at, :datetime)
    add_column(:users, :updated_at, :datetime)

    add_column(:hashtags, :created_at, :datetime)
    add_column(:hashtags, :updated_at, :datetime)

    add_column(:votes, :created_at, :datetime)
    add_column(:votes, :updated_at, :datetime)
  end
end
