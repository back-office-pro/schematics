# frozen_string_literal: true

class Hash
  def deep_flatten(prefix = nil)
    each_pair
      .reduce({}) do |hash, (key, value)|
        case value
        when Hash
          hash.merge value.deep_flatten "#{prefix}#{key}_"
        else
          hash.merge "#{prefix}#{key}": value
        end
      end
  end
end
