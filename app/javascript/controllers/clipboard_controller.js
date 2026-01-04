import ApplicationController from 'controllers/application_controller'
import { Tooltip } from 'bootstrap'

export default class extends ApplicationController {
  static get values () {
    return { text: String }
  }

  connect () {
    this.tooltip = new Tooltip(this.element) // eslint-disable-line no-new
  }

  copy () {
    navigator.clipboard.writeText(this.textValue)
    this.tooltip.show()
    setTimeout(() => this.tooltip.hide(), 1500)
  }
}
