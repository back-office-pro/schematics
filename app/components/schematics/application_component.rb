# frozen_string_literal: true

module Schematics
  class ApplicationComponent < ViewComponent::Base
    include Pagy::Backend
    include Turbo::StreamsHelper
    include Turbo::FramesHelper
    include ApplicationHelper

    delegate_missing_to :helpers

    def to_html
      render_in(view_context)
    end

    private

    def view_context
      super || ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)
    end
  end
end
