# Copyright © 2025 Dev & Software. All rights reserved.
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
    include ResourcesHelper
    extend ::Dry::Initializer

    delegate :current_user,
             :current_ability,
             :can?,
             :cannot?,
             :content_security_policy_nonce,
             :content_security_policy?,
             to: :helpers

    def to_html = ApplicationController
      .new
      .view_context
      .render(self)
  end
end
