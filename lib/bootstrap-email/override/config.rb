# frozen_string_literal: true

module BootstrapEmail
  module Override
    module Config
      def config_for_option(option)
        super.try(:call) || super
      end
    end
  end
end
