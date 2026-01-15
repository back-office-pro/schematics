# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::LicenseComparisonModal::SLIM = <<~SLIM
  #license-comparison-modal.modal.fade aria-hidden='true' tabindex='-1'
    .modal-dialog.modal-dialog-centered.modal-lg
      .modal-content.shadow-sm
        .modal-header.pb-1
          = __card_heading(icon:, title:, modal_title: true)
          button.btn-close.me-1 aria-label='Close' data-bs-dismiss='modal' type='button'
        .modal-body
          .row.g-4.justify-content-center
            .col-lg-6
              ul.list-group.list-group-striped
                li.list-group-item.text-center
                  h5.text-primary = t('.free_license')
                = __license_comparison_modal_list_item(model_class: User, count: quota[:USERS])
                = __license_comparison_modal_list_item(model_class: WebhookEndpoint, count: quota[:WEBHOOKS])
                = __license_comparison_modal_list_item(model_class: APIKey, count: quota[:API_KEYS])
                = __license_comparison_modal_list_item(model_class: Role, count: quota[:ROLES])
                = __license_comparison_modal_list_item(model_class: Team, count: quota[:TEAMS])
                = __license_comparison_modal_list_item(text: t('.entities'), icon: :circle_nodes, count: quota[:ENTITIES])
                = __license_comparison_modal_list_item(model_class: ActiveStorage::Attachment, text: t('.storage'), count: number_to_human_size(1.gigabyte))
                = __license_comparison_modal_list_item(icon: :headset, text: t('.email_support'), count: false)
                = __license_comparison_modal_list_item(model_class: Backup, count: 0)
                = __license_comparison_modal_list_item(icon: :file_csv, text: t('.export_csv_data'), count: 0)
                = __license_comparison_modal_list_item(icon: :ban, text: t('.commercial_use'), count: 0)
            .col-lg-6
              ul.list-group.list-group-striped
                li.list-group-item.text-center
                  h5.text-primary = t('.pro_license')
                = __license_comparison_modal_list_item(model_class: User)
                = __license_comparison_modal_list_item(model_class: WebhookEndpoint)
                = __license_comparison_modal_list_item(model_class: APIKey)
                = __license_comparison_modal_list_item(model_class: Role)
                = __license_comparison_modal_list_item(model_class: Team)
                = __license_comparison_modal_list_item(text: t('.entities'), icon: :circle_nodes)
                = __license_comparison_modal_list_item(model_class: ActiveStorage::Attachment, text: t('.storage'))
                = __license_comparison_modal_list_item(icon: :headset, text: t('.priority_email_support'), count: false)
                = __license_comparison_modal_list_item(model_class: Backup)
                = __license_comparison_modal_list_item(icon: :file_csv, text: t('.export_csv_data'), count: false)
                = __license_comparison_modal_list_item(icon: :handshake, text: t('.commercial_use'), count: false)
        .modal-footer
          = __license_comparison_modal_button_checkout
SLIM
