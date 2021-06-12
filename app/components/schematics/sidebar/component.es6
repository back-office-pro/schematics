/* global Stimulus, fetchAPI, application */

application.register('sidebar', class extends Stimulus.Controller {
  toggle () {
    document.querySelector('.sidebar').classList.toggle('toggled')
    document.querySelector('.content').classList.toggle('toggled')
    for (const element of document.querySelectorAll('.sidebar .d-none')) {
      element.classList.toggle('d-md-block')
    }
    const sidebarToggled = document.querySelector('.sidebar').classList.contains('toggled')
    fetchAPI('/preferences', 'PUT', { preferences: { sidebar_toggled: sidebarToggled } })
  }
})
