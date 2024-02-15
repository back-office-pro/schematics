# frozen_string_literal: true

module Schematics
  class ApplicationDoc < Object
    include OpenApi::DSL

    class << self
      def inherited(subclass)
        super
        subclass.include(Documentable::Inflectable)
      end
    end
  end
end
