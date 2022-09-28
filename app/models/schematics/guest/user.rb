# frozen_string_literal: true

module Schematics
  module Guest
    # :reek:Attribute
    class User
      include ::ActiveModel::API
      delegate :time_zone, to: 'Rails.configuration'
      attr_accessor :locale

      def admin? = false

      def preferences = {}

      def role = Role.new # rubocop:disable Lint/ConstantResolution
    end
  end
end
