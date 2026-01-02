# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Filter::Typeahead::SLIM = <<~SLIM
  .input-group.flex-nowrap data-controller='typeahead'
    = search_field_tag filter_name,
                       value,
                       minlength: 2,
                       placeholder: t('.prompt', attribute_name:),
                       autocomplete: 'off',
                       form:,
                       spellcheck: false,
                       data: { 'typeahead-target': 'input', action: },
                       class: css_classes
    ul.list-group.list-group-striped.shadow-sm.typeahead-results.position-absolute.z-2.top-100.w-100 {
      data-typeahead-target='results'
    }
    ul.list-group.list-group-striped.shadow-sm.typeahead-results.position-absolute.z-2.top-100.w-100.d-none {
      data-typeahead-target='history'
    }
      - history.each do |query|
        li.list-group-item.list-group-item-action.p-2.text-start.text-truncate {
          data-action='mousedown->typeahead#selectItem'
          data-typeahead-value-param=query
          role='button'
        }
          = fa_icon :history, class: 'text-secondary me-2'
          = query
SLIM
