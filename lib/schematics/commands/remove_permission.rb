# frozen_string_literal: true

require 'generators/permission/permission_generator'
require 'rails/generators'

module Schematics
  module Commands
    class RemovePermission < Command
      def generators = [
        PermissionGenerator.new([name], ["--action=#{attribute}"], behavior: :revoke)
      ]

      def weight = 4
    end
  end
end
