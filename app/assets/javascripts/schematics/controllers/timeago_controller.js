import ApplicationController from './application_controller'
import { render, register } from '../../timeago.js/esm/index'
import fr from '../../timeago.js/esm/lang/fr'

register('fr', fr)

export default class extends ApplicationController {
  connect () {
    render(this.element, document.documentElement.lang)
  }
}
