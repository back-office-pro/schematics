/* global Stimulus, fetchAPI, Routes */

window.SwitchThemeController = class extends Stimulus.Controller {
  lightTheme () {
    this.switchTheme('light')
  }

  darkTheme () {
    this.switchTheme('dark')
  }

  switchTheme (theme) {
    const newTheme = document.querySelector(`link#${theme}`)
    const oldTheme = document.querySelector(`link#${theme === 'light' ? 'dark' : 'light'}`)
    newTheme.disabled = false
    newTheme.setAttribute('media', 'all')
    setTimeout(() => { oldTheme.disabled = true }, 200)
    fetchAPI(Routes.schematicsPreferencesEn(), 'PUT', { preferences: { theme } })
  }
}
