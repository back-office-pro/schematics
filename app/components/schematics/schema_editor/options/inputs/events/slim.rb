# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::SchemaEditor::Options::Inputs::Events::SLIM = <<~SLIM
  .mb-3 data-controller='nested-form'
    = builder.label option_name, class: 'form-label'
    template#schema-editor-events-input data-nested-form-target='templates'
      .col-6.schema-editor-events-input
        = builder.fields_for option_name, state_machine_event do |events_form|
          = events_form.hidden_field :id, { name: "\#{events_form.object_name}[NEW_RECORD][id]" }
          = events_form.checkbox :confirm, { switch: true, name: "\#{events_form.object_name}[NEW_RECORD][confirm]" }, 'true', 'false'
          = events_form.text_field :name, { data: name_data, name: "\#{events_form.object_name}[NEW_RECORD][name]", maxlength:, floating: }
          = events_form.select :icon,
                               icons_collection,
                               { include_blank: include_blank('icon') },
                               { data: icon_data, name: "\#{events_form.object_name}[NEW_RECORD][icon]" }
          = events_form.select :color,
                               colors_collection,
                               { include_blank: include_blank('color') },
                               { data: color_data, name: "\#{events_form.object_name}[NEW_RECORD][color]" }
          = events_form.select :from,
                               [],
                               { include_hidden:, include_blank: },
                               { data:, name: "\#{events_form.object_name}[NEW_RECORD][from][]", multiple:, floating:, required: }
          = events_form.select :to, [], { include_blank: }, { data:, name: "\#{events_form.object_name}[NEW_RECORD][to]", floating:, required: }
          = events_form.text_field :callback, { data: popover_data, name: "\#{events_form.object_name}[NEW_RECORD][callback]", floating: }
        .btn.btn-sm.btn-danger {
          data-action='click->nested-form#remove:prevent:stop'
          data-nested-form-wrapper-param='.schema-editor-events-input'
          data-controller='tooltip'
          data-bs-title=t('.remove')
        } = fa_icon :trash
    .row.g-2#schema-editor-events-inputs data-nested-form-target='targets'
      - events.each_with_index do |event, index|
        .col-6.schema-editor-events-input
          = builder.fields_for option_name, event do |events_form|
            = events_form.hidden_field :id, { name: "\#{events_form.object_name}[\#{index}][id]" }
            = events_form.checkbox :confirm, { switch: true, name: "\#{events_form.object_name}[\#{index}][confirm]" }, 'true', 'false'
            = events_form.text_field :name, { data: name_data, name: "\#{events_form.object_name}[\#{index}][name]", maxlength:, floating: }
            = events_form.select :icon,
                                 icons_collection,
                                 { include_blank: include_blank('icon') },
                                 { data: icon_data, name: "\#{events_form.object_name}[\#{index}][icon]" }
            = events_form.select :color,
                                 colors_collection,
                                 { include_blank: include_blank('color') },
                                 { data: color_data, name: "\#{events_form.object_name}[\#{index}][color]" }
            = events_form.select :from,
                                 values,
                                 { include_hidden:, include_blank: },
                                 { data:, name: "\#{events_form.object_name}[\#{index}][from][]", multiple:, floating:, required: }
            = events_form.select :to, values, { include_blank: }, { data:, name: "\#{events_form.object_name}[\#{index}][to]", floating:, required: }
            = events_form.text_field :callback, { data: popover_data, name: "\#{events_form.object_name}[\#{index}][callback]", floating: }
          .btn.btn-sm.btn-danger {
            data-action='click->nested-form#remove:prevent:stop'
            data-nested-form-wrapper-param='.schema-editor-events-input'
            data-controller='tooltip'
            data-bs-title=t('.remove')
          } = fa_icon :trash
    .btn.btn-sm.btn-primary {
      data-action='click->nested-form#add:prevent'
      data-nested-form-template-id-param='schema-editor-events-input'
      data-nested-form-target-id-param='schema-editor-events-inputs'
      data-controller='tooltip'
      data-bs-title=t('.add')
    } = fa_icon :plus
SLIM
