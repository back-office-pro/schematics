# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::ResourceForm::Fields::OneTimePassword::SLIM = <<~SLIM
  .mb-3
    = form.label attribute_name, class: label_css_classes
    .input-group data-controller='one-time-password'
      - digits.times
        = form.text_field name,
                          hide_label:,
                          required:,
                          inputmode:,
                          control_class:,
                          autocomplete:,
                          multiple:,
                          wrapper_class:,
                          pattern:,
                          maxlength:,
                          data:
SLIM
