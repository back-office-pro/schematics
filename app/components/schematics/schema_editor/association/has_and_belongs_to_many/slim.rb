# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::SchemaEditor::Association::HasAndBelongsToMany::SLIM = <<~SLIM
  .col-xl-6.col-md-12.schema-editor-habtm-association.cursor-grab
    .card.shadow-sm
      .card-header.px-2.py-1.bg-body-tertiary
        .row.align-items-center
          .col.text-truncate.px-0
            = __card_heading(icon:, title:)
          .col-auto
            .btn-group
              = __schema_editor_button_options(builder:)
              = __schema_editor_button_remove(wrapper: '.schema-editor-habtm-association')
      .card-body
        = builder.select :name, allowed_names, { include_blank: }, { required: true, data: { controller: 'schema-editor--habtm-association-dropdown' } }
        = builder.select :type, collection, { required: true }, { required: true, data: { controller: 'dropdown' } }
        = __schema_editor_options_modal(builder:)
SLIM
