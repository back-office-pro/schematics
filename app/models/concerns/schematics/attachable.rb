# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attachable
    extend ActiveSupport::Concern

    included do
      include ActionText::Attachable
    end

    def to_partial_path = 'action_text/trix_attachment'
  end
end
