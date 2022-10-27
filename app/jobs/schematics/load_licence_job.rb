# frozen_string_literal: true

module Schematics
  class LoadLicenceJob < ApplicationJob
    def perform = ::Licence
      .instance
      .load!
  end
end
