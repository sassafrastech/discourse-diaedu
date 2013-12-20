# This migration comes from diaedu (originally 20130821172709)
class CreateDiaeduEvents < ActiveRecord::Migration
  def change
    create_table :diaedu_events do |t|
      t.string :name, :null => false

      t.timestamps
    end
    add_index :diaedu_events, :name, :unique => true
  end
end
