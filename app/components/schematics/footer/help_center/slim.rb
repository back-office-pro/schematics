# frozen_string_literal: true

Schematics::Footer::HelpCenter::SLIM = <<~SLIM
  .dropdown.d-inline-block.px-2.bg-body-secondary.rounded.btn-transparent
    a#support-dropdown.dropdown-toggle.text-decoration-none.text-body-secondary aria-expanded='false' data-bs-toggle='dropdown' role='button'
      = t('.text')
    .dropdown-menu.shadow-sm.animate__animated.animate__zoomIn.p-0.mb-2 aria-labelledby='support-dropdown'
      h5.dropdown-header.rounded-top.bg-body-tertiary.fw-bold = t('.title')
      = __footer_help_center_terms
      = __footer_help_center_privacy_policy
      = __footer_help_center_feature_requests
      = __button_help(:dropdown_item)
      = __button_support(:dropdown_item)
SLIM
