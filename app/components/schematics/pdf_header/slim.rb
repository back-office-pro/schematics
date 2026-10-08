# frozen_string_literal: true

Schematics::PDFHeader::SLIM = <<~SLIM
  .text.left style=style
    = company_name
  .text.center style=style
    = resource
  .text.right style=style
    span.pageNumber
    '/
    span.totalPages
SLIM
