# frozen_string_literal: true

Schematics::ResourceForm::SLIM = <<~SLIM
  = bootstrap_form_with model: @resource, url:, data:, layout: do |form|
    = form.hidden_field :lock_version
    - attributes.group_by(&:group).each do |group, fields|
      = __resource_form_form_group(group:, resource: @resource) do |c|
        - c.with_body do
          - fields.stable_sort_by(&:weight).each do |field|
            = turbo_frame_tag dom_id(@resource, field.name) do
              div class=wrapper_class
                = __resource_form_fields(form:, field:)
                = __button_confirm(compact: true) if turbo_frame_request?
                = __button_cancel(path: cancel_path, compact: true) if turbo_frame_request?
    = __button_confirm
    = __button_cancel(path: cancel_path)
SLIM
