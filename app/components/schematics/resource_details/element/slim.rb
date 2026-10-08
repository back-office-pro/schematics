# frozen_string_literal: true

Schematics::ResourceDetails::Element::SLIM = <<~SLIM
  - if editable?
    = __edit_in_place(resource:, element:)
  - else
    = __resource(resource:, element:, enable_buttons: enable_buttons?)
SLIM
