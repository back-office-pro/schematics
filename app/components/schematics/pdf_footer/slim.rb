# frozen_string_literal: true

Schematics::PDFFooter::SLIM = <<~SLIM
  .text.left style=style
    = company_website
  .text.center style=style
    = company_address
  .text.right style=style
    = company_registration_number
SLIM
