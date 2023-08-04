import ApplicationController from 'controllers/application_controller'

/* global routes */

export default class extends ApplicationController {
  keepOpened () {}

  toggleColumn (event) {
    const { id, checked } = event.target
    document.querySelectorAll(`.${id}`).forEach(element => {
      element.classList.add('animate__animated')
      element.classList.toggle('d-none')
    })
    this.fetchAPI(routes.preferences, 'PUT', { preferences: { [id]: checked } })
  }
}
