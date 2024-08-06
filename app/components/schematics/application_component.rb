# frozen_string_literal: true

module Schematics
  class ApplicationComponent < ::ViewComponent::Base
    include ::Pagy::Backend
    include ::Pagy::Frontend
    include ::Turbo::StreamsHelper
    include ::Turbo::FramesHelper
    include ::Turbo::DriveHelper
    include ::Importmap::ImportmapTagsHelper
    include ApplicationHelper
    extend ::Dry::Initializer

    use_helpers :current_user,
                :current_ability,
                :can?,
                :content_security_policy_nonce,
                :content_security_policy?

    def preferences(key, default = nil)
      current_user
        .preferences
        .fetch(key.to_s, default)
    end

    def to_html = ApplicationController
      .new
      .view_context
      .render(self)
  end
end
