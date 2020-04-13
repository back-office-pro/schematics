module Schematics
  module Virtuals
    module Errors
      class NameError < ::NameError
        def to_s
          "#{name} not defined" unless super.include?("nil:NilClass")
        end
      end
    end
  end
end
