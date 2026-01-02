# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::SchemaEditor::Template::Association::HasAndBelongsToMany::SLIM = <<~SLIM
  template#schema-editor-habtm-association data-nested-form-target='templates'
    = form.fields_for :entities, entity, child_index: 'INDEX' do |entity_builder|
      = entity_builder.fields_for :has_and_belongs_to_many_associations, association, child_index: 'NEW_RECORD' do |builder|
        = __schema_editor_association_has_and_belongs_to_many(builder:)
SLIM
