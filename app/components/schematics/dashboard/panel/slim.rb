# frozen_string_literal: true

Schematics::Dashboard::Panel::SLIM = <<~SLIM
  .tab-pane.fade role='tabpanel' id=id class=css_classes
    .row.g-3 data=data('metrics')
      = __onboarding
      = __metric(metrics)
    .row.g-3.pt-3 data=data('charts')
      = __chart(charts, id:)
    .row.g-3.pt-3 data=data('rankings')
      = __ranking(rankings)
SLIM
