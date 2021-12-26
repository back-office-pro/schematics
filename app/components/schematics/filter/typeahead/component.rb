# frozen_string_literal: true

module Schematics
  module Filter
    module Typeahead
      class Component < Filter::Component
        def action
          %w[
            keyup->typeahead#search
            search->typeahead#onSearch
            search->typeahead#clearResults
            search->typeahead#showHistory
            focus->typeahead#onFocus
            blur->typeahead#hideHistory
            blur->typeahead#hideResults
          ].join(' ')
        end

        def history
          Search
            .where(user: current_user, model: @model_class.to_s, query: nil)
            .order(created_at: :desc)
            .limit(5)
            .pluck(:filters)
            .pluck(name)
            .uniq
            .compact
        end
      end
    end
  end
end
