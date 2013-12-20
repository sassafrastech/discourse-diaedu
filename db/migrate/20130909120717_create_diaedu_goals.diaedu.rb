# This migration comes from diaedu (originally 20130826151727)
class CreateDiaeduGoals < ActiveRecord::Migration
  def change
    create_table :diaedu_goals do |t|
      t.string :name, :null => false
      t.text :description, :null => false

      t.timestamps
    end
    add_index :diaedu_goals, :name, :unique => true
  end
end
