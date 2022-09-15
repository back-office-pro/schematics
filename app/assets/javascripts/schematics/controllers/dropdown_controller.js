import ApplicationController from './application_controller'
import SlimSelect from 'slim-select'

/* global I18n */

export default class extends ApplicationController {
  static get values () {
    return { data: Array }
  }

  connect () {
    new SlimSelect(this.options) // eslint-disable-line no-new
  }

  disconnect () {
    this.element.slim.destroy()
  }

  setDependentDropdownsOptions ({ value }) {
    document
      .querySelectorAll(`[data-dropdown-depends-on="${this.element.name}"]`)
      .forEach(element => {
        element.slim.setData(
          Array
            .from(element.options)
            .map(option => ({
              value: option.value,
              text: option.innerText,
              class: !option.value.startsWith(value) && 'd-none'
            }))
        )
        element.value = null
      })
  }

  get options () {
    return {
      select: this.element,
      data: this.dataValue.length && this.dataValue,
      onChange: this.setDependentDropdownsOptions.bind(this),
      searchingText: I18n.typeahead.pending,
      searchText: I18n.slimSelect.searchText,
      searchPlaceholder: I18n.slimSelect.searchPlaceholder,
      placeholder: I18n.slimSelect.placeholder,
      searchFocus: true,
      searchHighlight: true,
      showSearch: true
    }
  }
}
