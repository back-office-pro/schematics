# frozen_string_literal: true

Schematics::Favicon::SLIM = <<~SLIM
  = favicon_link_tag(path, type:)
  = favicon_link_tag(path, type:, rel: 'apple-touch-icon')
SLIM
