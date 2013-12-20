# This migration comes from diaedu (originally 20131111172151)
class FixTaggingTable < ActiveRecord::Migration
  def change
    rename_column :diaedu_taggings, :taggable_id, :obj_id
    remove_column :diaedu_taggings, :taggable_type
  end
end
