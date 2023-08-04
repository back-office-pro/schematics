import ApplicationController from 'controllers/application_controller'

/* global routes */

export default class extends ApplicationController {
  switchTheme (event) {
    document.documentElement.setAttribute('data-bs-theme', event.params.theme)
    this.fetchAPI(routes.preferences, 'PUT', { preferences: { theme: event.params.theme } })
    event.stopPropagation()
  }
}
