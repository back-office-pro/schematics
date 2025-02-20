# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module LinkPreview
    module Popover
      class Component < ApplicationComponent
        delegate :image, :title, :description, to: :link_preview
        option :link_preview
      end
    end
  end
end
