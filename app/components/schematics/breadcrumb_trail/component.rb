module Schematics
  module BreadcrumbTrail
    class Component < ::ViewComponent::Base
      delegate :fa_icon, :breadcrumb_trail, to: :helpers
      delegate :root_path, to: 'Schematics::Engine.routes.url_helpers'
    end
  end
end
