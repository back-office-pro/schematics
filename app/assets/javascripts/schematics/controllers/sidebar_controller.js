import ApplicationController from './application_controller'
import { schematicsPreferencesEn } from 'routes'

export default class extends ApplicationController {
  toggle () {
    this.element.classList.toggle('toggled')
    this.element.querySelectorAll('.d-none').forEach(_ => _.classList.toggle('d-md-block'))
    document.querySelector('.content').classList.toggle('toggled')
    const sidebarToggled = this.element.classList.contains('toggled')
    this.fetchAPI(schematicsPreferencesEn(), 'PUT', { preferences: { sidebar_toggled: sidebarToggled } })
  }
}
