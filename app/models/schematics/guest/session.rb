# frozen_string_literal: true

module Schematics
  module Guest
    # :reek:MissingSafeMethod
    class Session
      delegate :ip, :user_agent, to: :@request

      def initialize(request:)
        @request = request
      end

      def locale = @request
        .env['HTTP_ACCEPT_LANGUAGE']
        &.scan(/^[a-z]{2}/)
        &.to_a
        &.first
        &.to_sym

      def login!(user)
        PaperTrail.request(enabled: false) do
          ::Session.create!(ip:, user_agent:, user:)
        end
      end

      def update!(*); end

      def user = User.new(locale:) # rubocop:disable Lint/ConstantResolution
    end
  end
end
