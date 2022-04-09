import { Controller } from '../../@hotwired/stimulus/dist/stimulus'

/* global bootstrap */

export default class extends Controller {
  connect () {
    new bootstrap // eslint-disable-line no-new
      .Toast(this.element)
      .show()
  }
}
