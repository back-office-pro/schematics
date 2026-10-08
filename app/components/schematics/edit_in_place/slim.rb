# frozen_string_literal: true

Schematics::EditInPlace::SLIM = <<~SLIM
  = form_with model: resource, url:, data: { turbo_frame: frame_id } do
    = turbo_frame_tag frame_id do
      = link_to edit_resource_path(resource), class: 'edit-in-place text-decoration-none' do
        = __resource(resource:, element:, enable_buttons: true)
SLIM
