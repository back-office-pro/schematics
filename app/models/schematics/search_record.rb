# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SearchRecord < ::ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    self.abstract_class = true

    class << self
      def current_shard = :"#{super}/search"
    end
  end
end
