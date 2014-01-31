ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    # recent objs
    columns do
      column do
        panel "Recent Submissions" do
          ul do
            Diaedu::KbObj.recent_unapproved(20).map do |obj|
              li link_to("[#{obj.type.demodulize}] #{obj.name}", send("edit_#{obj.class.admin_route_key}_path", obj))
            end
          end
        end
      end
    end
  end # content
end
