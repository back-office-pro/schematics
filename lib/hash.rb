# frozen_string_literal: true

class Hash
  # :reek:FeatureEnvy
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

  # :reek:FeatureEnvy
  def flatten_to_nested(separator = '.')
    each_with_object({}) do |(key, value), all|
      key_parts = key.split(separator).map!(&:to_sym)
      leaf = key_parts[0...-1].reduce(all) { |acc, elem| acc[elem] ||= {} }
      leaf[key_parts.last] = value
    end
  end
end
