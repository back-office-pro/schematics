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
    return this.modalId ? document.querySelector(`span[data-bs-target="#${this.modalId}"]`) : this.element
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(input => ({ key: input.value, value: input.value }))
      .sort((a, b) => a.text - b.text)
  }

  get options () {
    return {
      trigger: '$',
      values: this.collection,
      menuItemLimit: 5,
      noMatchTemplate: () => null
    }
  }
}
