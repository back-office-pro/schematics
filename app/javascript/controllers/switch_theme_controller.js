import ApplicationController from 'controllers/application_controller'

/* global routes */

export default class extends ApplicationController {
  switchTheme ({ params: { theme } }) {
    document.documentElement.classList.toggle('dark-mode')
    document.documentElement.setAttribute('data-bs-theme', theme)
    this.fetchAPI(routes.preferences, 'PUT', { user: { preferences: { theme } } })
  }
}
