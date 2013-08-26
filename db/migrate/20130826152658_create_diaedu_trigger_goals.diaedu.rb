# This migration comes from diaedu (originally 20130826151755)
class CreateDiaeduTriggerGoals < ActiveRecord::Migration
  def change
    create_table :diaedu_trigger_goals do |t|
      t.integer :trigger_id, :null => false
      t.integer :goal_id, :null => false
      t.foreign_key :diaedu_triggers, :column => 'trigger_id'
      t.foreign_key :diaedu_goals, :column => 'goal_id'

      t.timestamps
    end
  end
end
