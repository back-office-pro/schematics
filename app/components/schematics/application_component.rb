# frozen_string_literal: true

module Schematics
  class ApplicationComponent < ::ViewComponent::Base
    include ::ViewComponent::RendersOneForm
    include ::Pagy::Backend
    include ::Pagy::Frontend
    include ::Turbo::StreamsHelper
    include ::Turbo::FramesHelper
    include ApplicationHelper
    extend ::Dry::Initializer

    delegate :current_user,
             :current_ability,
             :can?,
             :content_security_policy_nonce,
             to: :helpers

    def to_html = render_in view_context

    private

    def view_context
      super || ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)
    end
  end
end
