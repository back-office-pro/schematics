# frozen_string_literal: true

Schematics::Resource::SLIM = <<~SLIM
  span.text-body-tertiary = '-' if value.nil?
  - case element
  - when Schematics::Associations::Association, Schematics::Attributes::Association
    - if value
      - if value.deleted?
        .text-body-secondary
          = fa_icon :box_archive, class: 'me-2'
          = value
      - else
        - case value
        - when User
          = __avatar(user: value, width: 18, height: 18, size: :xl)
        - else
          = __resource_link_to(resource: value)
  - when Schematics::Attributes::Array
    - value.each do |element|
      span.badge.bg-primary.me-1 = element
  - when Schematics::Attributes::Jsonb
    - case value
    - in Schematics::Schema
      = __viewer_schema(schema: value)
    - in { openapi:, tags:, paths:, security:, components: }
      = __viewer_swagger(spec: value)
    - else
      pre.mb-0
        code == code_highlight(JSON.pretty_generate(value), language: 'json') if value
  - when Schematics::Attributes::Url
    = __link_preview(url: value)
  - when Schematics::Attributes::Color
    .btn.p-2.pe-none style="background: \#{value};"
  - when Schematics::Attributes::Attachments
    = __viewer_association(resources: value, highlight_text:)
  - when Schematics::Attributes::Attachment
    - if value.attached?
      = __button_destroy_attachment(attachment: value.attachment) if enable_buttons?
      - if value.representable?
        = __attachment_preview_modal(attachment: value.attachment, icon: element.icon)
        span data-bs-toggle='modal' data-bs-target="#attachment-preview-modal-\#{value.id}"
          = __attachment(attachment: value.attachment, class: 'rounded', role: 'button')
      - else
        = __resource_link_to(resource: value.attachment)
  - when (value in StandardError) && Schematics::Virtuals::Virtual
    span.text-danger
      = fa_icon(:triangle_exclamation, class: 'me-2')
      = element.format(value)
  - when Schematics::Attributes::Boolean, Schematics::Virtuals::Comparison
    - case value
    - when TrueClass
      = fa_icon(:check, class: 'text-success')
    - when FalseClass
      = fa_icon(:xmark, class: 'text-danger')
  - when Schematics::Attributes::StateMachine
    h5.mb-0
      span.badge class="bg-\#{badge_color}" = element.format(value)
  - when Schematics::Attributes::RichText
    == value
  - when Schematics::Attributes::Code
    pre.mb-0
      code == code_highlight(value, language: element.language)
  - when Schematics::Attributes::Country
    span.fi.rounded class="fi-\#{value&.downcase}"
  - when Schematics::Attributes::Phone
    - if phone_country
      span.fi.rounded.me-2 class="fi-\#{phone_country}"
    = element.format(value)
  - when Schematics::Attributes::Model
    = __resource_link_to(resource: value)
  - when Schematics::Attributes::Rating
    == stars(value)
  - when Schematics::Attributes::ResponseCode
    span.badge.bg-primary = element.format(value)
  - when Schematics::Attributes::Token
    = __button_clipboard(value:)
  - when Schematics::Attributes::Secret
    = value&.gsub(/.(?<=.{4})/, '*')
  - when Schematics::Attributes::Percentage
    .progress.fs-6 role='progressbar' aria-valuenow=value aria-valuemin='0' aria-valuemax='100'
      .progress-bar style="width: \#{value}%"
        = element.format(value)
  - when Schematics::Behaviours::Searchable
    = highlight element.format(value), highlight_text
  - else
    = element.format(value)
SLIM
