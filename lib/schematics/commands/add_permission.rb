# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails/generators'
require 'generators/permission/permission_generator'

module Schematics
  module Commands
    class AddPermission < Command
      def generators = [
        PermissionGenerator.new([class_name], ["--action=#{attribute}"])
      ]

      def weight = 3
    end
  end
end
