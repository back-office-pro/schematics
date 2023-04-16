# frozen_string_literal: true

module Schematics
  module Behaviours
    module Identifiable
      attr_writer :id

      def id
        @id ||= SecureRandom.uuid
      end
    end
  end
end
