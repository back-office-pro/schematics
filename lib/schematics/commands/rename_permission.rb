# frozen_string_literal: true

require 'generators/permission/permission_generator'
require 'rails/generators'

module Schematics
  module Commands
    class RenamePermission < Command
      def generators = [
        PermissionGenerator.new(
          [name],
          ["--action=#{target}", "--rename=#{attribute}"],
          behavior: :revoke
        )
      ]

      def weight = 4
    end
  end
end
