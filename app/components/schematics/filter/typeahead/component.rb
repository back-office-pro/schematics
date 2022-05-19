# frozen_string_literal: true

module Schematics
  module Filter
    module Typeahead
      class Component < Filter::Component
        def action = %w[
          keyup->typeahead#search
          search->typeahead#onSearch
          search->typeahead#clearResults
          search->typeahead#showHistory
          focus->typeahead#onFocus
          blur->typeahead#hideHistory
          blur->typeahead#hideResults
        ].join(' ')

        def history
          current_user.typeahead_history(@model_class.to_s, name)
        end
      end
    end
  end
end
