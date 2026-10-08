# frozen_string_literal: true

module Schematics
  module Identifiable
    extend ActiveSupport::Concern

    included do
      after_initialize :assign_id
    end

    class_methods do
      def generate_ulid = BasedUUID
        .encode(uuid: SecureRandom.uuid)
        .encode(Encoding::UTF_8)
    end

    def assign_id
      self.id ||= self.class.generate_ulid
    end
  end
end
