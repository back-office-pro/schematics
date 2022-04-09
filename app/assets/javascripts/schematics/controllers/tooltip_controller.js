import { Controller } from '../../@hotwired/stimulus/dist/stimulus'

/* global bootstrap */

export default class extends Controller {
  connect () {
    new bootstrap.Tooltip(this.element) // eslint-disable-line no-new
  }
}
