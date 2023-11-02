import ApplicationController from 'controllers/application_controller'

/* global routes */

export default class extends ApplicationController {
  toggle () {
    this.element.classList.toggle('toggled')
    this.element.querySelectorAll('.d-none').forEach(_ => _.classList.toggle('d-md-block'))
    document.querySelector('.content').classList.toggle('toggled')
    const sidebarToggled = this.element.classList.contains('toggled')
    const data = { user: { preferences: { sidebar_toggled: sidebarToggled } } }
    this.fetchAPI(routes.preferences, 'PUT', data)
  }
}
