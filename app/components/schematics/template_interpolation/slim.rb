# frozen_string_literal: true

Schematics::TemplateInterpolation::SLIM = <<~SLIM
  .container-fluid
    == interpolation
    - if interpolation_errors.any?
      ul.list-group.list-group-striped
        li.list-group-item.text-danger = t('.warning')
        - interpolation_errors.each do |error|
          li.list-group-item.text-danger
            = fa_icon :triangle_exclamation, class: 'me-2'
            = error.to_s(false)
SLIM
