# frozen_string_literal: true

module Schematics
  module Attributes
    class OneTimePassword < Attribute
      include Behaviours::Encryptable

      def database_type = 'string'

      def encrypted? = true

      def default = nil

      def icon = :mobile_screen

      def to_str = super + <<~RUBY
        has_one_time_password column_name: :#{name}
      RUBY
    end
  end
end
