# frozen_string_literal: true

require 'open_api'

Rails.configuration.after_initialize do
  OpenApi::Config.class_eval do
    self.doc_location = Schematics::Engine.root.join('app', 'docs', 'schematics', '*_doc.rb')
    open_api :open_api, base_doc_classes: [
      Schematics::ResourcesController,
      Schematics::ApplicationDoc
    ]
  end
end
