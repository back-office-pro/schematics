module Schematics
  module Behaviours
    module Range
      module Filterable
        def filter_scope
          super.extends <<~RUBY
            (from, to) do
              return where("#{entity.type.pluralize}.#{name} <= ?", to) if from.nil?
              return where("#{entity.type.pluralize}.#{name} >= ?", from) if to.nil?
              return where("#{entity.type.pluralize}.#{name} >= ? AND #{entity.type.pluralize}.#{name} <= ?", from, to)
            end
          RUBY
        end

        def has_filter_scope
          super.extends_with_comma <<~RUBY
            using: [:from, :to]
          RUBY
        end
      end
    end
  end
end
