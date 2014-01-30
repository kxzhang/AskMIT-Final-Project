class LastUsedHashtags < ActiveRecord::Migration
  def change
    add_column(:hashtags, :last_used, :datetime)
  end
end
