# frozen_string_literal: true

Schematics::SchemaEditor::Button::AddDropdown::SLIM = <<~SLIM
  .btn-group data-bs-toggle='dropdown'
    button.btn.btn-sm.btn-primary.dropdown-toggle {
      aria-expanded='false'
      data-controller='tooltip'
      data-bs-title=title
    }
      = fa_icon :plus
    .dropdown-menu.dropdown-menu-end.shadow-sm.animate__animated.animate__zoomIn.p-0 {
        aria-labelledby='entity-dropdown'
      }
      h5.dropdown-header.rounded-top.bg-body-tertiary.fw-bold
        = title
      .pre-scrollable.overflow-scroll
        - [most_used_collection, advanced_collection].each do |collection|
          - collection.each do |constant|
            .dropdown-item {
              data-action='click->nested-form#add:prevent'
              data-nested-form-template-id-param="schema-editor-attribute-\#{constant.type.dasherize}"
              data-nested-form-target-id-param="fields-\#{index}"
              data-nested-form-index-param=index
              role='button'
            }
              = fa_icon constant.new(entity:).icon, class: 'me-2'
              = t('.add_attribute', type: constant.model_name.human.downcase)
          .dropdown-divider
        .dropdown-item {
          data-action='click->nested-form#add:prevent'
          data-nested-form-template-id-param='schema-editor-virtual'
          data-nested-form-target-id-param="fields-\#{index}"
          data-nested-form-index-param=index
          role='button'
        }
          = fa_icon :plus, class: 'me-2'
          = t('.add_virtual')
        .dropdown-divider
        .dropdown-item {
          data-action='click->nested-form#add:prevent'
          data-nested-form-template-id-param='schema-editor-trigger'
          data-nested-form-target-id-param="fields-\#{index}"
          data-nested-form-index-param=index
          role='button'
        }
          = fa_icon :atom, class: 'me-2'
          = t('.add_trigger')
        .dropdown-divider
        .dropdown-item {
          data-action='click->nested-form#add:prevent'
          data-nested-form-template-id-param='schema-editor-attribute-belongs-to-has-one'
          data-nested-form-target-id-param="fields-\#{index}"
          data-nested-form-index-param=index
          role='button'
        }
          = fa_icon :link, class: 'me-2'
          = t('.add_belongs_to_has_one')
        .dropdown-item {
          data-action='click->nested-form#add:prevent'
          data-nested-form-template-id-param='schema-editor-attribute-belongs-to'
          data-nested-form-target-id-param="fields-\#{index}"
          data-nested-form-index-param=index
          role='button'
        }
          = fa_icon :link, class: 'me-2'
          = t('.add_belongs_to_has_many')
        .dropdown-item {
          data-action='click->nested-form#add:prevent'
          data-nested-form-template-id-param='schema-editor-habtm-association'
          data-nested-form-target-id-param="fields-\#{index}"
          data-nested-form-index-param=index
          role='button'
        }
          = fa_icon :link, class: 'me-2'
          = t('.add_habtm_association')
        .dropdown-item {
          data-action='click->nested-form#add:prevent'
          data-nested-form-template-id-param='schema-editor-attribute-user'
          data-nested-form-target-id-param="fields-\#{index}"
          data-nested-form-index-param=index
          role='button'
        }
          = fa_icon :users, class: 'me-2'
          = t('.add_user_association')
SLIM
