# frozen_string_literal: true

Schematics::EmailFooter::SLIM = <<~SLIM
  .row.text-muted.mt-1
    .col-6.text-left
      small = company_address
    .col-6.text-right
      small = company_website
SLIM
