# frozen_string_literal: true

Schematics::GoogleMap::MissingAPIKey::SLIM = <<~SLIM
  .row.justify-content-center
    .card.bg-body-tertiary.google-map-placeholder
      .card-body.d-flex.align-items-center.justify-content-center.text-danger
        = fa_icon icon, size: '3x'
        = title
SLIM
