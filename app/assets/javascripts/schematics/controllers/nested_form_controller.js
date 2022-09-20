import ApplicationController from './application_controller'
import ClientSideValidations from '@client-side-validations/client-side-validations'

export default class extends ApplicationController {
  static get targets () {
    return ['targets', 'templates', 'form']
  }

  add ({ params: { templateId, targetId, index } }) {
    const timestamp = new Date().getTime().toString()
    const template = this.templatesTargets.find(_ => _.id === templateId)
    const target = this.targetsTargets.find(_ => _.id === targetId)
    const content = template
      .innerHTML
      .replace(/NEW_RECORD/g, timestamp)
      .replace(/INDEX/g, index == null ? timestamp : index)
    target.insertAdjacentHTML('beforeend', content)
    if (this.hasFormTarget) {
      ClientSideValidations.reset(this.formTarget)
    }
  }

  remove (event) {
    event.target.closest(event.params.wrapper).remove()
  }
}
