import ApplicationController from 'controllers/application_controller'
import Sortable from 'sortablejs'

export default class extends ApplicationController {
  connect () {
    Sortable.create(this.element, this.options)
  }

  get options () {
    return {
      filter: 'input',
      preventOnFilter: false
    }
  }
}
