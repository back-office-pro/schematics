# frozen_string_literal: true

module Schematics
  class ApplicationComponent < ::ViewComponent::Base
    include ::ViewComponent::UseHelpers
    include ::Pagy::Backend
    include ::Pagy::Frontend
    include ::Turbo::StreamsHelper
    include ::Turbo::FramesHelper
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

    def to_html = render_in view_context

    private

    def view_context
      super || ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)
    end
  end
end
