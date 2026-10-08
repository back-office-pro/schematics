# frozen_string_literal: true

Schematics::Exception::UnsupportedBrowser::SLIM = <<~SLIM
  .d-flex.flex-column.align-items-center.justify-content-center.text-white
    = fa_icon icon, size: '7x'
    h3.mt-4.pt-4 = title
    .mt-4 = __button_support
SLIM
