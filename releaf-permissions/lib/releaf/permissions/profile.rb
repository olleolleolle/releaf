module Releaf::Permissions::Profile

  def self.initialize_component
    Releaf.application.config.additional_controllers.push('releaf/permissions/profile')
  end

  def self.draw_component_routes router
    router.namespace :releaf, path: nil do
      router.get "profile", to: "permissions/profile#edit", as: :permissions_user_profile
      router.patch "profile", to: "permissions/profile#update"
    end
  end
end
