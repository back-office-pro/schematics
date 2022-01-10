# frozen_string_literal: true

require 'open_api'

Rails.application.config.after_initialize do
  OpenApi::Config.class_eval do
    self.file_output_path = 'doc/api'
    open_api :open_api, base_doc_classes: [Schematics::ApplicationController]
  end
end
