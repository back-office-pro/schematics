# frozen_string_literal: true

Schematics::Viewer::Comments::SLIM = <<~SLIM
  #comments.offcanvas.offcanvas-end data-controller='offcanvas' tabindex='-1' data-bs-scroll='true'
    .offcanvas-header.ps-2
      = __card_heading(icon:, title:)
      = __button_add(model_class:, resource:)
      button.btn-close.text-reset.pe-4 aria-label='Close' data-bs-dismiss='offcanvas' type='button'
    .offcanvas-body.pt-0
      = turbo_frame_tag 'comments', data: { turbo_action: 'advance' } do
        = __comment_preview(@comments)
        = __viewer_pagination(pagy: @pagy)
SLIM
