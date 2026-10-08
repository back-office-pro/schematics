# frozen_string_literal: true

Schematics::Layout::SLIM = <<~SLIM
  .container-fluid.p-0.bg-body-tertiary
    .row.g-0.h-100
      = __sidebar
      .col.content.d-flex.flex-column class=css_class
        = __navbar
        .container-fluid.my-1.px-3
          = content
        = __footer
SLIM
