import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static get values () {
    return { text: String }
  }

  copy () {
    navigator.clipboard.writeText(this.textValue)
  }
}
