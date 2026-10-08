# frozen_string_literal: true

Schematics::ConfirmDialog::SLIM = <<~SLIM
  .modal.fade {
    id=target
    data-controller='modal'
    data-bs-backdrop='static'
    data-bs-keyboard='false'
    aria-hidden='true'
    tabindex='-1'
  }
    .modal-dialog.modal-dialog-centered.modal-sm
      .modal-content.shadow-sm
        .modal-header.pb-1
          = __card_heading(title:, modal_title: true)
          button.btn-close aria-label='Close' data-bs-dismiss='modal' type='button'
        .modal-body.text-center
          = fa_icon :triangle_exclamation, size: '2x', class: 'text-danger'
          .pt-2 = text
        .modal-footer
          = __button_confirm
          = __button_cancel(data: { 'bs-dismiss': 'modal' })
SLIM
