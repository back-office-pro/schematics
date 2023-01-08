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
      plugins: ['no_active_items', 'remove_button'],
      onChange: this.setDependentDropdownsOptions.bind(this),
      render: {
        no_results: () => I18n.typeahead.notFound,
        loading: () => I18n.typeahead.pending
      }
    }
  }
}
