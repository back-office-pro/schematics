/* global Stimulus, fetchAPI, Routes */

window.ViewerSettingsController = class extends Stimulus.Controller {
  keepOpened (e) {
    e.stopPropagation()
  }

  toggleColumn (e) {
    const { id, checked } = e.target
    document.querySelectorAll(`.${id}`).forEach(element => {
      element.classList.add('animate__animated')
      element.classList.toggle('d-none')
    })
    fetchAPI(Routes.schematicsPreferencesEn(), 'PUT', { preferences: { [id]: checked } })
  }
}
