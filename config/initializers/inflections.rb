# frozen_string_literal: false

ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural(/^(\w+)\s(.+)$/, '\1s \2')
end
