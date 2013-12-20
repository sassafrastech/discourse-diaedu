# This migration comes from diaedu (originally 20130823211819)
class CreateDiaeduTriggers < ActiveRecord::Migration
  def change
    create_table :diaedu_triggers do |t|
      t.string :name, :null => false
      t.text :description, :null => false
      
      t.timestamps
    end
    add_index :diaedu_triggers, :name, :unique => true
  end
end
