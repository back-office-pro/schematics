# frozen_string_literal: true

require 'rails/generators'
require 'generators/permission/permission_generator'

module Schematics
  module Commands
    class RemovePermission < Command
      def generators = [
        PermissionGenerator.new([name], ["--action=#{attribute}"], behavior: :revoke)
      ]

      def weight = 3
    end
  end
end
