# frozen_string_literal: true

module Schematics
  module Filter
    module Typeahead
      class Component < Filter::Component
        def action
          %w[
            keyup->typeahead#search
            search->typeahead#onSearch
            focus->typeahead#showResults
            blur->typeahead#hideResults
          ].join(' ')
        end
      end
    end
  end
end
