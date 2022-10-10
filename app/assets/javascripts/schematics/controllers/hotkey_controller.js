import ApplicationController from 'controllers/application_controller'
import { install, uninstall } from '@github/hotkey'

export default class extends ApplicationController {
  static get values () {
    return { shortcut: String }
  }

  connect () {
    install(this.element, this.shortcutValue)
    this.element.title = this.shortcutValue
  }

  disconnect () {
    uninstall(this.element)
  }
}
