# frozen_string_literal: true

Schematics::SearchBarModal::SLIM = <<~SLIM
  #search-bar-modal.modal.fade aria-hidden='true' tabindex='-1'
    .modal-dialog.modal-dialog-centered.modal-lg
      .modal-content.shadow-sm
        .modal-body
          = form_with model:, url:, class: 'd-flex' do |f|
            .position-relative.w-100 data-controller='search-bar' data-search-bar-highlight-value='false'
              = f.search_field :query,
                               required: true,
                               minlength: 3,
                               placeholder: t('.placeholder'),
                               class: 'form-control bg-transparent',
                               autocomplete: 'off',
                               spellcheck: false,
                               data: { 'search-bar-target': 'input', action: }
              ul.list-group.list-group-striped.shadow-sm.typeahead-results.position-absolute.top-100.w-100 {
                data-search-bar-target='results'
              }
              ul.list-group.list-group-striped.shadow-sm.typeahead-results.position-absolute.top-100.w-100.d-none {
                data-search-bar-target='history'
              }
                - history.each do |query|
                  li.list-group-item.list-group-item-action.p-2.text-start.text-truncate {
                    data-action='mousedown->search-bar#selectItem'
                    data-search-bar-url-param=resource_path(Search.new(id: query))
                    role='button'
                  }
                    = fa_icon :history, class: 'text-secondary me-2'
                    = query
            = f.button class: 'btn' do
              span.icon = fa_icon :magnifying_glass, class: 'fa-lg'
              span.icon.d-none = fa_icon :spinner, animation: 'spin'
SLIM
