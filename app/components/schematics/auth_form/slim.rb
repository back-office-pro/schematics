# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::AuthForm::SLIM = <<~SLIM
  = bootstrap_form_with model:, scope:, url: do |form|
    = form.email_field :email,
                       autocomplete: 'username',
                       autofocus: true,
                       prepend: fa_icon(:envelope)
    = __resource_form_fields_digest(form:)
    = form.checkbox :remember_me, switch: true
    = __button_confirm
    = link_to t('.password_lost?'), new_password_reset_path, class: 'btn btn-link btn-sm text-decoration-none'
SLIM
