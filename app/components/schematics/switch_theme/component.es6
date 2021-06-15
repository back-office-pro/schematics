/* global Stimulus, fetchAPI */

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
    newTheme.removeAttribute('disabled')
    setTimeout(() => oldTheme.setAttribute('disabled', 'disabled'), 200)
    fetchAPI('/preferences', 'PUT', { preferences: { theme: theme } })
  }
}
