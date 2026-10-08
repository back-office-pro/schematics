# frozen_string_literal: true

Schematics::ResourceForm::Fields::HasMany::Template::SLIM = <<~SLIM
  template id=id data-nested-form-target='templates'
    = form.fields_for name, model_class.new, child_index: 'NEW_RECORD' do |form|
      .card.shadow-sm.animate__animated.animate__zoomIn.mb-3 class=css_class
        .card-header.p-2.bg-body-tertiary
          .row.align-items-center
            .col.text-truncate.px-1
              = __card_heading(icon:, title: human_name.humanize)
            .col-auto
              = __resource_form_fields_has_many_button_remove(field:)
        .card-body.pb-0
          = __resource_form_fields(elements, form:)
SLIM
