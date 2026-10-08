# frozen_string_literal: true

Schematics::GoogleMap::SLIM = <<~SLIM
  - if gcloud_public_api_key
    iframe.google-map.rounded src=url width='300' height='300'
  - else
    = __google_map_missing_api_key
SLIM
