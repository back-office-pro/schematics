import ApplicationController from './application_controller'

/* global bootstrap */

export default class extends ApplicationController {
  connect () {
    new bootstrap // eslint-disable-line no-new
      .Toast(this.element)
      .show()
  }
}
