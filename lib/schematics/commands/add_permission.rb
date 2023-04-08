# frozen_string_literal: true

require 'generators/permission/permission_generator'
require 'rails/generators'

module Schematics
  module Commands
    class AddPermission < Command
      def generators = [
        PermissionGenerator.new([name], ["--action=#{attribute}"])
      ]

      def weight = 4
    end
  end
end
