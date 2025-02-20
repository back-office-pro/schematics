# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Themeable
    extend ActiveSupport::Concern

    included do
      after_action :set_color_scheme_headers
    end

    private

    def set_color_scheme_headers
      response.headers['Critical-CH'] = 'Sec-CH-Prefers-Color-Scheme'
      response.headers['Accept-CH'] = 'Sec-CH-Prefers-Color-Scheme'
      response.headers['Vary'] = 'Sec-CH-Prefers-Color-Scheme'
    end
  end
end
