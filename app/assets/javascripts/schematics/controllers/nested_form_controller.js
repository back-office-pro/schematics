import ApplicationController from './application_controller'
import ClientSideValidations from '@client-side-validations/client-side-validations'

export default class extends ApplicationController {
  static get targets () {
    return ['templates', 'form']
  }

  add (event) {
    event.preventDefault()
    const template = this.templatesTargets.find(_ => _.id === event.params.template)
    const content = template.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString())
    template.insertAdjacentHTML('beforebegin', content)
    ClientSideValidations.reset(this.formTarget)
  }

  remove (event) {
    event.preventDefault()
    event.target.closest(event.params.wrapper).remove()
  }
}
