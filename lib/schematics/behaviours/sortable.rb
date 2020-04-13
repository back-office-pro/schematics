module Schematics
  module Behaviours
    module Sortable
      def sort_scope
        <<~RUBY
          scope :sort_by_#{name}, ->
        RUBY
      end

      def has_sort_scope
        <<~RUBY
          has_scope :sort_by_#{name}, only: :index
        RUBY
      end
    end
  end
end
