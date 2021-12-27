/* global Stimulus, fetchAPI, Routes */

window.SidebarController = class extends Stimulus.Controller {
  toggle () {
    document.querySelector('.sidebar').classList.toggle('toggled')
    document.querySelector('.content').classList.toggle('toggled')
    document.querySelectorAll('.sidebar .d-none').forEach(element => {
      element.classList.toggle('d-md-block')
    })
    const sidebarToggled = document.querySelector('.sidebar').classList.contains('toggled')
    fetchAPI(Routes.schematicsPreferencesEn(), 'PUT', { preferences: { sidebar_toggled: sidebarToggled } })
  }
}
