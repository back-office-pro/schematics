# frozen_string_literal: true

module Schematics
  module Readable
    extend ActiveSupport::Concern

    def read!
      return unless @resource.try(:readable?)
      return if @resource.users.exclude?(current_user)

      Version
        .where(event: 'show', item: @resource, user: current_user)
        .first_or_create!
    end
  end
end
