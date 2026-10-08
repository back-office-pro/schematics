import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  static get values () {
    return { percentage: Number }
  }

  connect () {
    this.element.style.setProperty('--percentage', this.percentageValue)
  }
}
