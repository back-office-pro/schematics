module Schematics
  module Behaviours
    module Filterable
      def filter_scope
        <<~RUBY
          scope :by_#{name}, ->
        RUBY
      end

      def has_filter_scope
        <<~RUBY
          has_scope :by_#{name}, only: :index
        RUBY
      end
    end
  end
end
