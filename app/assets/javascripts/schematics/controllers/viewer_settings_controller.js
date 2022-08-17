import ApplicationController from './application_controller'

/* global routes */

export default class extends ApplicationController {
  keepOpened () {}

  toggleColumn (e) {
    const { id, checked } = e.target
    document.querySelectorAll(`.${id}`).forEach(element => {
      element.classList.add('animate__animated')
      element.classList.toggle('d-none')
    })
    this.fetchAPI(routes.preferences, 'PUT', { preferences: { [id]: checked } })
  }
}
