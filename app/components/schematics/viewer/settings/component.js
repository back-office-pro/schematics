import { Controller } from '../../@hotwired/stimulus/dist/stimulus'

/* global fetchAPI, Routes */

export class ViewerSettingsController extends Controller {
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
