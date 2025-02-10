# frozen_string_literal: true

module Schematics
  module EmailFooter
    class Component < ApplicationComponent
      delegate :company_website, :company_address, to: '::Configuration'
    end
  end
end
