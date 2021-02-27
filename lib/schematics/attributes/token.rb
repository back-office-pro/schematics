require 'schematics/attributes/attribute'

module Schematics
  module Attributes
    class Token < Attribute
      def api_param_type
        'string'
      end

      def to_str
        <<~RUBY
          has_secure_token :#{@name}
        RUBY
      end
    end
  end
end
