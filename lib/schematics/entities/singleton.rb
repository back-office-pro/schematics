module Schematics
  module Entities
    class Singleton < Entity
      def route
        <<~RUBY
          resource :#{name.pluralize}, only: [:show, :edit, :update]
          resolve("#{class_name}") { [:#{name}] }
        RUBY
      end

      def to_str
        super + <<~RUBY
          acts_as_singleton
        RUBY
      end
    end
  end
end
