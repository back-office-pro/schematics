import { Controller } from '../../@hotwired/stimulus/dist/stimulus'
import Sortable from '../../sortablejs/modular/sortable.esm'

export default class extends Controller {
  connect () {
    Sortable.create(this.element)
  }
}
