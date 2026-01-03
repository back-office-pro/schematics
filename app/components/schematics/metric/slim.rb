# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Metric::SLIM = <<~SLIM
  .col-xl-3.col-md-6.cursor-grab data-id=id
    .card.animate__animated.animate__zoomIn
      .card-body.p-3
        .row.g-3.align-items-center
          .col.text-truncate
            small.text-uppercase.text-primary.fw-bold
              = @metric
            - if threshold
              .row.g-2
                .col
                  .progress.fs-6 role='progressbar' aria-valuenow=value aria-valuemin='0' aria-valuemax=threshold
                    .progress-bar class=background_css_class style="width: \#{percentage}%"
                      = "\#{value.to_f} / \#{threshold}"
                .col-auto.text-truncate.fw-bold
                  = __metric_trend(metric:)
            - else
              .mb-0.text-secondary.text-truncate.fw-bold
                span.me-1 = value_formatted
                = __metric_trend(metric:)
          .col-auto
            - if model_class
              = __resource_link_to(resource: model_class) do |c|
                - c.with_body do
                  = fa_icon icon, size: '2x', class: 'text-body-tertiary'
            - else
              = fa_icon icon, size: '2x', class: 'text-danger'
SLIM
