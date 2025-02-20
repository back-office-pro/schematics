# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module LinkPreview
    def title
      super || url
    end
  end
end
