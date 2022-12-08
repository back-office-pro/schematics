# frozen_string_literal: true

module Schematics
  module Guest
    # :reek:MissingSafeMethod
    # :reek:Attribute
    class Session
      include ::ActiveModel::API
      delegate :ip, :user_agent, to: :request
      attr_accessor :request

      def locale = request
        .env['HTTP_ACCEPT_LANGUAGE']
        &.scan(/^[a-z]{2}/)
        &.to_a
        &.first
        &.to_sym

      def login!(user)
        PaperTrail.request(enabled: false) do
          user.module_parent::Session.create!(ip:, user_agent:, user:)
        end
      end

      def touch!(*) = true

      def user = User.new(locale:)
    end
  end
end
