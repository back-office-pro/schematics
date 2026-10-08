# frozen_string_literal: true

Schematics::VersionPreview::SLIM = <<~SLIM
  .row {
    data-action=action
    data-application-href-param=href
    role=role
  }
    .col-auto.align-self-center
      = __avatar(user:)
    .col.text-truncate
      = __resource_link_to(resource: item)
      .text-body-secondary = version.reify(dup: true).to_s unless item
      .text-body-tertiary data-controller='timeago' datetime=created_at
    .col-auto.align-self-center
      = fa_icon(icon, size: '2x', class: 'text-body-tertiary')
SLIM
