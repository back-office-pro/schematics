import { Controller } from '../@hotwired/stimulus/dist/stimulus'

/* global fetchAPI, Routes */

export class SwitchThemeController extends Controller {
  switchTheme ({ params: { theme }}) {
    const newTheme = document.querySelector(`link#${theme}`)
    const oldTheme = document.querySelector(`link#${theme === 'light' ? 'dark' : 'light'}`)
    newTheme.disabled = false
    newTheme.setAttribute('media', 'all')
    setTimeout(() => { oldTheme.disabled = true }, 200)
    fetchAPI(Routes.schematicsPreferencesEn(), 'PUT', { preferences: { theme } })
  }
}
