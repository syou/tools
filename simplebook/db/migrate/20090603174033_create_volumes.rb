class CreateVolumes < ActiveRecord::Migration
  def self.up
    create_table :volumes do |t|
      t.string :subtitle
      t.integer :book_id
      t.integer :author_id
      t.integer :no

      t.timestamps
    end
  end

  def self.down
    drop_table :volumes
  end
end
