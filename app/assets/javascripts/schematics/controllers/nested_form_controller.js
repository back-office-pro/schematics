import ApplicationController from 'controllers/application_controller'

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
      .replace(/INDEX/g, index == null ? timestamp : index)
    target.insertAdjacentHTML('afterbegin', content)
  }

  remove (event) {
    event.target.closest(event.params.wrapper).remove()
  }
}
