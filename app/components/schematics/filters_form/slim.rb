# frozen_string_literal: true

Schematics::FiltersForm::SLIM = <<~SLIM
  = form_with url:, method:, id:, data:, class: css_classes do
    = submit_tag nil, name: nil, class: 'd-none'
    - query_params.each do |query|
      = hidden_field_tag query, params[query]
SLIM
