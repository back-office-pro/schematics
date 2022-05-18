# frozen_string_literal: true

module Schematics
  module Behaviours
    module Searchable
      def search_data = <<~RUBY.squish
        #{name}:
      RUBY
    end
  end
end
