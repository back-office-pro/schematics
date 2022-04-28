import ApplicationController from './application_controller'
import { schematicsPreferencesEn } from 'routes'

export default class extends ApplicationController {
  keepOpened (e) {
    e.stopPropagation()
  }

  toggleColumn (e) {
    const { id, checked } = e.target
    document.querySelectorAll(`.${id}`).forEach(element => {
      element.classList.add('animate__animated')
      element.classList.toggle('d-none')
    })
    this.fetchAPI(schematicsPreferencesEn(), 'PUT', { preferences: { [id]: checked } })
  }
}
