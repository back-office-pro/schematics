# frozen_string_literal: true

Schematics::ResourceForm::Fields::Attachments::SLIM = <<~SLIM
  - signed_ids.each do |value|
    = form.hidden_field name.to_sym, multiple:, value:
  .mb-1 data-controller='attachments-previewer'
    = form.file_field name.to_sym, help:, multiple:, include_hidden:, accept:, required:, data:
    div data-attachments-previewer-target='container'
SLIM
