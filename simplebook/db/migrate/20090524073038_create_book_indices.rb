class CreateBookIndices < ActiveRecord::Migration
  def self.up
    create_table :book_indices do |t|
      t.string :name
      t.integer :genrae
      t.string :character

      t.timestamps
    end
  end

  def self.down
    drop_table :book_indices
  end
end
