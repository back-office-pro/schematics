import ApplicationController from 'controllers/application_controller'
import Sortable from 'sortablejs'

/* global routes */

export default class extends ApplicationController {
  static get values () {
    return { group: { type: String } }
  }

  connect () {
    Sortable.create(this.element, this.options)
  }

  get options () {
    return {
      filter: 'input',
      preventOnFilter: false,
      animation: 150,
      group: this.groupValue,
      store: {
        set: (sortable) => {
          if (this.groupValue !== '') {
            const preferences = { [this.groupValue]: sortable.toArray() }
            this.fetchAPI(routes.preferences, 'PUT', { preferences })
          }
        }
      }
    }
  }
}
