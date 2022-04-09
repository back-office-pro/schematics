import ApplicationController from './application_controller'
import Sortable from '../../sortablejs/modular/sortable.esm'

export default class extends ApplicationController {
  connect () {
    Sortable.create(this.element)
  }
}
