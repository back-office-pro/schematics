import ApplicationController from 'controllers/application_controller'
import TomSelect from 'tom-select'

/* global I18n */

export default class extends ApplicationController {
  connect () {
    new TomSelect(this.element, this.options) // eslint-disable-line no-new
  }

  disconnect () {
    this.element.tomselect.destroy()
  }

  setDependentDropdownsOptions (value) {
    document
      .querySelectorAll(`[data-dropdown-depends-on="${this.element.name}"]`)
      .forEach(element => {
        element.tomselect.clear()
        element.tomselect.clearOptions()
        element.tomselect.addOptions(
          Array
            .from(element.options)
            .filter(option => option.value.startsWith(value))
            .map(option => ({ value: option.value, text: option.text }))
        )
      })
  }

  get options () {
    return {
      plugins: ['no_active_items', !this.required && 'remove_button'],
      itemClass: this.multiple ? 'item bg-primary text-white' : 'item',
      onChange: this.setDependentDropdownsOptions.bind(this),
      render: {
        no_results: () => `<div class="option opacity-100 text-muted">
          <i class="fa fa-exclamation-triangle text-secondary fa-fw me-2"></i>
          ${I18n.typeahead.notFound}
        </div>`,
        loading: () => `<div class="option opacity-100 text-muted">
          <i class="fa fa-spinner fa-spin text-secondary fa-fw me-2"></i>
          ${I18n.typeahead.pending}
        </div>`
      }
    }
  }

  get required () {
    return this.element.getAttribute('required') === 'required'
  }

  get multiple () {
    return this.element.getAttribute('multiple') === 'multiple'
  }
}
