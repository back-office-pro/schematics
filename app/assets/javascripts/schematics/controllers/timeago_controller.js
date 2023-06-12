import ApplicationController from 'controllers/application_controller'
import { render, register, cancel } from 'timeago.js'
import fr from 'timeago.fr.js'
import it from 'timeago.it.js'

register('fr', fr)
register('it', it)

export default class extends ApplicationController {
  connect () {
    render(this.element, document.documentElement.lang)
  }

  disconnect () {
    cancel(this.element)
  }
}
