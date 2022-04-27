import ApplicationController from './application_controller'
import { schematicsPreferencesEn } from 'routes'

export default class extends ApplicationController {
  switchTheme ({ params: { theme } }) {
    const newTheme = document.querySelector(`link#${theme}`)
    const oldTheme = document.querySelector(`link#${theme === 'light' ? 'dark' : 'light'}`)
    newTheme.disabled = false
    newTheme.setAttribute('media', 'all')
    setTimeout(() => { oldTheme.disabled = true }, 200)
    this.fetchAPI(schematicsPreferencesEn(), 'PUT', { preferences: { theme } })
  }
}
