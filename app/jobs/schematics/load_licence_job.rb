# frozen_string_literal: true

module Schematics
  class LoadLicenceJob < ApplicationJob
    def perform = Core::Licence
      .instance
      .load!
  end
end
