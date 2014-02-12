ActiveAdmin.register Diaedu::Barrier, :as => 'Barrier' do

  actions :all, :except => [:show]

  menu :priority => 12

  config.sort_order = "name_asc"

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :approved
    column :created_at
    actions
  end

  filter :approved, :as => :select
  filter :name
  filter :description

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :description
      f.input :children, :label => 'Associated Goals', :collection => Diaedu::Goal.default_order.all,
        :as => :select2, :placeholder => 'Enter a Goal'
      f.input :tags, :collection => Diaedu::Tag.default_order.all, :as => :select2, :placeholder => 'Enter a Tag'
      f.input :approved
    end
    f.actions
  end

  permit_params :name, :description, :approved, :child_ids => [], :tag_ids => []

end
