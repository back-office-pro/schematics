import ApplicationController from 'controllers/application_controller'

/* global crypto */

export default class extends ApplicationController {
  static get targets () {
    return ['targets', 'templates']
  }

  add ({ params: { templateId, targetId, index } }) {
    const timestamp = new Date().getTime().toString()
    const template = this.templatesTargets.find(_ => _.id === templateId)
    const target = this.targetsTargets.find(_ => _.id === targetId)
    const content = template
      .innerHTML
      .replace(/NEW_RECORD/g, timestamp)
      .replace(/RANDOM_UUID/g, crypto.randomUUID())
      .replace(/INDEX/g, index ?? timestamp)
    target.insertAdjacentHTML('afterbegin', content)
  }

  remove ({ target, params }) {
    target.closest(params.wrapper).remove()
  }
}
