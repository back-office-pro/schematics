import ApplicationController from 'controllers/application_controller'
import Sortable from 'sortablejs'

/* global routes */

export default class extends ApplicationController {
  static get values () {
    return {
      group: { type: String },
      subgroup: { type: String },
      targets: { type: Array, default: [] }
    }
  }

  connect () {
    Sortable.create(this.element, this.options)
  }

  save (sortable) {
    if (this.groupValue !== '' && this.subgroupValue !== '') {
      const preferences = { [this.groupValue]: { [this.subgroupValue]: sortable.toArray() } }
      this.fetchAPI(routes.preferences, 'PUT', { user: { preferences } })
    }
  }

  get options () {
    return {
      filter: '.sortable-disabled, input',
      draggable: '.cursor-grab',
      preventOnFilter: false,
      animation: 150,
      ghostClass: 'opacity-50',
      group: { name: this.groupValue, put: this.targetsValue },
      store: { set: this.save.bind(this) }
    }
  }
}
