# frozen_string_literal: true

Schematics::Footer::SLIM = <<~SLIM
  footer
    .row.mx-1.text-secondary.align-items-center.h-100
      .col.text-start.text-nowrap
        | &copy; \#{year} \#{company_name}
        = __footer_network
        = __footer_help_center
      .col.text-end.text-nowrap
        = __resource_link_to(resource:)
        = fa_icon :rocket, class: 'text-primary mx-1'
        .d-none.d-sm-inline
          span.ms-1 = t('.powered_by')
        = link_to website_url, class: 'ms-1', target: '_blank', rel: 'noreferrer' do
          = image_tag 'logo.svg'
SLIM
