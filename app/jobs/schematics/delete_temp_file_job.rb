# frozen_string_literal: true

module Schematics
  class DeleteTempFileJob < ApplicationJob
    def perform(filepath)
      File.delete Rails.root.join('tmp', filepath)
    end
  end
end
