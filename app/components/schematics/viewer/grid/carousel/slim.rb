# frozen_string_literal: true

Schematics::Viewer::Grid::Carousel::SLIM = <<~SLIM
  .carousel.slide.z-0 id=id data-bs-ride='carousel'
    .carousel-inner
      - attachments.each_with_index do |attachment, index|
        = __viewer_resource_link(resource:, css_classes: css_classes(index)) do |c|
          - c.with_body do
            .d-inline-block.text-body-tertiary.carousel-placeholder
              = __attachment(attachment:, class: 'rounded')
    button.carousel-control-prev type='button' data-bs-slide='prev' data-bs-target="#\#{id}"
      span.carousel-control-prev-icon aria-hidden='true'
      span.visually-hidden &#x3c;
    button.carousel-control-next type='button' data-bs-slide='next' data-bs-target="#\#{id}"
      span.carousel-control-next-icon aria-hidden='true'
      span.visually-hidden &#x3e;
SLIM
