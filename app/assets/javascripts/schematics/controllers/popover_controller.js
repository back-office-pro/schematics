import ApplicationController from 'controllers/application_controller'
import { Popover } from 'bootstrap'

export default class extends ApplicationController {
  connect () {
    this.#setTableAllowList()
    new Popover(this.element) // eslint-disable-line no-new
  }

  #setTableAllowList () {
    Popover.Default.allowList.table = []
    Popover.Default.allowList.thead = []
    Popover.Default.allowList.tbody = []
    Popover.Default.allowList.tr = []
    Popover.Default.allowList.th = []
    Popover.Default.allowList.td = []
  }
}
