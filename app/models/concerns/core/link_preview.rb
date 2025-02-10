# frozen_string_literal: true

module Core
  module LinkPreview
    def title
      super || url
    end
  end
end
