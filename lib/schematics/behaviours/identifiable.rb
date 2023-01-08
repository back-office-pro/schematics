# frozen_string_literal: true

module Schematics
  module Behaviours
    module Identifiable
      def id
        @id ||= SecureRandom.uuid
      end
    end
  end
end
