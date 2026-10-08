# frozen_string_literal: true

Schematics::Viewer::Specifications::Section::SLIM = <<~SLIM
  li.list-group-item class=@item_class
    - @indent.times do
      = fa_icon @icon, class: 'invisible me-2'
    = fa_icon @icon, class: 'me-2'
    == interpolate(@element)
  = __viewer_specifications_options(element: @element, indent: @indent.next, icon: :gear) if @options
SLIM
