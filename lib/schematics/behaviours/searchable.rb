module Schematics
  module Behaviours
    module Searchable
      def search_field
        name
      end

      def search_alias
        <<~RUBY
          ransack_alias :#{name}, :#{search_field}
        RUBY
      end
    end
  end
end
