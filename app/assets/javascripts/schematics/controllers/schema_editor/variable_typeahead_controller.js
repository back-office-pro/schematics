import ApplicationController from 'controllers/application_controller'
import Tribute from 'tributejs'

export default class extends ApplicationController {
  connect () {
    this.tribute = new Tribute(this.options)
    this.tribute.attach(this.element)
  }

  disconnect () {
    this.tribute.detach(this.element)
  }

  get inputs () {
    return this
      .element
      .closest('.schema-editor-entity')
      .querySelectorAll('.entity_field_name')
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
