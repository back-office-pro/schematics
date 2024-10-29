import ApplicationController from 'controllers/application_controller'
import Tribute from 'tributejs'

export default class extends ApplicationController {
  initialize () {
    this.tribute = new Tribute(this.options)
    this.tribute.attach(this.element)
  }

  get inputs () {
    return this
      .parentElement
      .closest('.schema-editor-entity')
      .querySelectorAll('.entity-field-name')
  }

  get modalId () {
    return this
      .element
      .closest('.modal')
      ?.getAttribute('id')
  }

  get parentElement () {
    return this.modalId ? document.querySelector(`div[data-bs-target="#${this.modalId}"]`) : this.element
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(input => ({ key: input.value, value: input.value }))
      .sort((a, b) => a.value.localeCompare(b.value))
  }

  get options () {
    return {
      trigger: '$',
      values: (_, callback) => callback(this.collection),
      containerClass: 'tribute-container list-group list-group-striped shadow-sm',
      itemClass: 'list-group-item list-group-item-action p-2 border-0 text-start text-truncate',
      menuItemLimit: 5,
      noMatchTemplate: () => null
    }
  }
}
