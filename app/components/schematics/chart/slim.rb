# frozen_string_literal: true

Schematics::Chart::SLIM = <<~SLIM
  .cursor-grab class=col_classes data-id=id
    .card.shadow-sm.animate__animated.animate__zoomIn
      .card-header.px-1.py-2
        = __card_heading(icon:, title: @chart)
      .card-body.p-3.pt-1.pb-2
        = __chart_helper(chart: @chart, dashboard_id: @dashboard_id)
SLIM
