# frozen_string_literal: true

module Schematics
  module Readable
    extend ActiveSupport::Concern

    TIMESTAMP_FIELD = :read_at
    RECIPIENT_FIELD = :recipient

    def update_timestamp_field?
      return unless @resource.respond_to?(TIMESTAMP_FIELD)
      return if @resource.send(TIMESTAMP_FIELD).present?
      return unless (@resource.try(RECIPIENT_FIELD) || current_user) == current_user

      @resource.update(TIMESTAMP_FIELD => Time.current)
    end
  end
end
