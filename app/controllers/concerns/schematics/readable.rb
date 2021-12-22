# frozen_string_literal: true

module Schematics
  module Readable
    extend ActiveSupport::Concern

    def read!
      return unless resource.respond_to?(:recipient)
      return unless current_user == resource.recipient

      Version
        .where(event: 'read', item: resource, user: current_user)
        .first_or_create!
    end
  end
end
