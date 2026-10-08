# frozen_string_literal: true

require 'rails/generators'
require 'generators/permission/permission_generator'

module Schematics
  module Commands
    class AddPermission < Command
      def generators = [permission_generator].compact

      def permission_generator
        return if abstract?

        PermissionGenerator.new([class_name], ["--action=#{attribute}"])
      end

      def weight = 3
    end
  end
end
