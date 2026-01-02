# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::ResourceForm::Fields::SLIM = <<~SLIM
  - case field
  - when Schematics::Associations::HasAndBelongsToMany
    = __resource_form_fields_has_and_belongs_to_many(form:, field:)
  - when Schematics::Associations::HasMany
    = __resource_form_fields_has_many(form:, field:)
  - when Schematics::Attributes::BelongsTo
    = __resource_form_fields_belongs_to(form:, field:)
  - when Schematics::Attributes::Time
    = __resource_form_fields_time(form:, field:)
  - when Schematics::Attributes::Datetime
    = __resource_form_fields_datetime(form:, field:)
  - when Schematics::Attributes::Date
    = __resource_form_fields_date(form:, field:)
  - when Schematics::Attributes::Array
    = __resource_form_fields_array(form:, field:)
  - when Schematics::Attributes::Address
    = __resource_form_fields_address(form:, field:)
  - when Schematics::Attributes::Email
    = __resource_form_fields_email(form:, field:)
  - when Schematics::Attributes::Url
    = __resource_form_fields_url(form:, field:)
  - when Schematics::Attributes::Phone
    = __resource_form_fields_phone(form:, field:)
  - when Schematics::Attributes::Color
    = __resource_form_fields_color(form:, field:)
  - when Schematics::Attributes::ModelField
    = __resource_form_fields_model_field(form:, field:)
  - when Schematics::Attributes::Flag
    = __resource_form_fields_flag(form:, field:)
  - when Schematics::Behaviours::Enumerable
    = __resource_form_fields_enumerable(form:, field:)
  - when Schematics::Attributes::String
    = __resource_form_fields_string(form:, field:)
  - when Schematics::Attributes::Code
    = __resource_form_fields_code(form:, field:)
  - when Schematics::Attributes::Text
    = __resource_form_fields_text(form:, field:)
  - when Schematics::Attributes::Jsonb
    = __resource_form_fields_jsonb(form:, field:)
  - when Schematics::Attributes::Rating
    = __resource_form_fields_rating(form:, field:)
  - when Schematics::Attributes::RichText
    = __resource_form_fields_rich_text(form:, field:)
  - when Schematics::Attributes::Attachments
    = __resource_form_fields_attachments(form:, field:)
  - when Schematics::Attributes::Attachment
    = __resource_form_fields_attachment(form:, field:)
  - when Schematics::Attributes::Secret
    = __resource_form_fields_secret(form:, field:)
  - when Schematics::Attributes::Digest
    = __resource_form_fields_digest(form:, field:, autocomplete: 'new-password')
  - when Schematics::Attributes::OneTimePassword
    = __resource_form_fields_one_time_password(form:, field:)
  - when Schematics::Attributes::Boolean
    = __resource_form_fields_boolean(form:, field:)
  - when Schematics::Behaviours::Numerable
    = __resource_form_fields_numerable(form:, field:)
SLIM
