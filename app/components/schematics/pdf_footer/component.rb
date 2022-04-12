# frozen_string_literal: true

module Schematics
  module PdfFooter
    class Component < ApplicationComponent
      delegate :company_name,
               :company_address,
               :company_registration_number,
               to: :settings,
               private: true

      def settings
        @settings ||= ::Setting.instance
      end
    end
  end
end
