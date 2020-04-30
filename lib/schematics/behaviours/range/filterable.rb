module Schematics
  module Behaviours
    module Range
      module Filterable
        def filter_scope
          super.extends <<~RUBY
            (from, to) do
              return where("#{to_sql} <= ?", to) if from.nil?
              return where("#{to_sql} >= ?", from) if to.nil?
              return where("#{to_sql} >= ? AND #{to_sql} <= ?", from, to)
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
