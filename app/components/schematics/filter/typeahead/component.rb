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
          ::Search.user_typeahead_history(current_user, @model_class.to_s, name)
        end
      end
    end
  end
end
