# frozen_string_literal: true

Schematics::CommentPreview::SLIM = <<~SLIM
  .card.shadow-sm.animate__animated.animate__zoomIn.mb-3
    .card-header.p-2.bg-body-tertiary
      .row.align-items-center
        .col.text-truncate.text-primary.fw-bold
          span = author
          span.mx-1 -
          span data-controller='timeago' datetime=created_at
        .col-auto
          .btn-group
            = __button_edit(resource: @comment)
            = __button_destroy(resource: @comment)
    .card-body.p-3
      == content
SLIM
