# frozen_string_literal: true

Schematics::Viewer::Timeline::SLIM = <<~SLIM
  = turbo_frame_tag 'timeline', data: { turbo_action: 'advance' } do
    .row.justify-content-center.mt-4
      .col-xl-9.col-md-12.position-relative
        ul.timeline.list-unstyled
          - @versions.each do |version|
            li
              .timeline-icon.bg-primary
                = fa_icon version.icon, size: '2x', class: 'text-white'
              .card.animate__animated.animate__zoomIn
                .card-body.p-3
                  = __version_preview(version:)
    = __viewer_pagination(pagy: @pagy)
SLIM
