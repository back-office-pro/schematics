# frozen_string_literal: true

module Schematics
  class ApplicationDoc < Object
    include OpenApi::DSL

    class << self
      def inherited(subclass)
        super
        subclass.include(Documentable::Inflectable)
        subclass.include(Documentable::Pageable)
      end
    end
  end
end
