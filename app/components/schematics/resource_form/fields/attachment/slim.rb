# frozen_string_literal: true

Schematics::ResourceForm::Fields::Attachment::SLIM = <<~SLIM
  - if attached?
    = form.fields_for attributes_param_key, layout: :inline do |fields|
      = fields.hidden_field :id, value: value.id
      = fields.checkbox :_destroy, switch:, label:, wrapper_class:
  .mb-1 data-controller='attachments-previewer'
    = form.file_field name.to_sym, help:, accept:, required:, data:
    div data-attachments-previewer-target='container'
SLIM
