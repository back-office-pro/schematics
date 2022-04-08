import { Controller } from '../../@hotwired/stimulus/dist/stimulus'
import { render, register } from '../../timeago.js/esm/index'
import fr from '../../timeago.js/esm/lang/fr'

register('fr', fr)

export default class extends Controller {
  connect () {
    render(this.element, document.documentElement.lang)
  }
}
