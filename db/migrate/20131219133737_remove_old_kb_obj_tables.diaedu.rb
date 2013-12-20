# This migration comes from diaedu (originally 20131219133320)
class RemoveOldKbObjTables < ActiveRecord::Migration
  def change
    drop_table :diaedu_glyprob_triggers
    drop_table :diaedu_trigger_goals
    drop_table :diaedu_glyprobs
    drop_table :diaedu_goals
    drop_table :diaedu_triggers
  end
end
