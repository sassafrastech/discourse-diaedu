ActiveAdmin.register Diaedu::Tag, :as => 'Tag' do

  actions :all, :except => [:show]

  menu :priority => 16

  config.sort_order = "name_asc"

  index do
    selectable_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
    end
    f.actions
  end

  permit_params :name

end
