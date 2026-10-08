# frozen_string_literal: true

Schematics::EmptyResource::SLIM = <<~SLIM
  .text-center.text-primary
    = fa_icon :database, size: '4x'
    h5.mt-3 = title
SLIM
