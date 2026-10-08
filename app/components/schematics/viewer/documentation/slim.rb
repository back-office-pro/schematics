# frozen_string_literal: true

Schematics::Viewer::Documentation::SLIM = <<~SLIM
  #documentation.offcanvas.offcanvas-end data-controller='offcanvas' tabindex='-1' data-bs-scroll='true'
    .offcanvas-header.ps-1
      = __card_heading(icon:, title:)
      button.btn-close.text-reset.ms-2 aria-label='Close' data-bs-dismiss='offcanvas' type='button'
    .offcanvas-body.p-0
      = __viewer_specifications_entity(entity:)
SLIM
