# frozen_string_literal: true

module Schematics
  class DeleteTempFileJob < ApplicationJob
    def perform(filepath)
      File.delete(filepath) if File.exist?(filepath)
    end
  end
end
