ActiveAdmin.register Diaedu::Glyprob, :as => 'Glycemic Problem' do

  actions :all, :except => [:show]

  menu :priority => 10

  config.sort_order = "diaedu_events.name_asc"

  controller do
    def scoped_collection
      resource_class.includes(:event)
    end
  end

  index do
    selectable_column
    column :id
    column :event, :sortable => 'diaedu_events.name'
    column :evaluation
    column :description
    column :approved
    column :created_at
    actions
  end

  filter :approved, :as => :select
  filter :description
  filter :evaluation, :as => :check_boxes, :collection => Diaedu::Eval.all
  filter :event

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :evaluation, :as => :select, :collection => Diaedu::Eval.all
      f.input :event
      f.input :description
      f.input :children, :label => 'Associated Triggers', :collection => Diaedu::Trigger.default_order.all,
        :as => :select2, :placeholder => 'Enter a Trigger'
      f.input :tags, :as => :select2, :placeholder => 'Enter a Tag'
      f.input :approved
    end
    f.actions
  end

  permit_params :name, :description, :approved, :evaluation, :event_id, :child_ids => [], :tag_ids => []

end
