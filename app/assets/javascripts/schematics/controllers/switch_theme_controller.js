import ApplicationController from './application_controller'

/* global routes */

export default class extends ApplicationController {
  switchTheme ({ params: { theme } }) {
    const newTheme = document.querySelector(`link#${theme}`)
    const oldTheme = document.querySelector(`link#${theme === 'light' ? 'dark' : 'light'}`)
    newTheme.disabled = false
    newTheme.setAttribute('media', 'all')
    setTimeout(() => { oldTheme.disabled = true }, 200)
    this.fetchAPI(routes.preferences, 'PUT', { preferences: { theme } })
  }
}
