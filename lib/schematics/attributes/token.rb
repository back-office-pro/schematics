require 'schematics/attributes/attribute'

module Schematics
  module Attributes
    class Token < Attribute
      def to_str
        <<~RUBY
          has_secure_token :#{@name}
        RUBY
      end
    end
  end
end
