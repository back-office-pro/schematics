# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Breadcrumbable
    extend ActiveSupport::Concern

    included do
      helper_method :breadcrumb_trail, :breadcrumb
    end

    def breadcrumb_trail
      @breadcrumb_trail ||= []
    end

    def breadcrumb(title, path)
      breadcrumb_trail << [title, path]
    end
  end
end
