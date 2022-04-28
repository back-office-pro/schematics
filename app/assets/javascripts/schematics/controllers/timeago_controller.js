import ApplicationController from './application_controller'
import { render, register, cancel } from 'timeago.js'
import fr from 'timeago.fr.js'

register('fr', fr)

export default class extends ApplicationController {
  connect () {
    render(this.element, document.documentElement.lang)
  }

  disconnect () {
    cancel(this.element)
  }
}
