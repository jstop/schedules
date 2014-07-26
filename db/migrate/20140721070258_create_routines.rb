class CreateRoutines < ActiveRecord::Migration
  def change
    create_table :routines do |t|
      t.string :title
      t.text :purpose
      t.string :resources
      t.integer :weeks
      t.integer :days
      t.integer :hours
      t.integer :minutes
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
