import { Controller } from '../@hotwired/stimulus/dist/stimulus'

/* global fetchAPI, Routes */

export class SidebarController extends Controller {
  toggle () {
    this.element.classList.toggle('toggled')
    this.element.querySelectorAll('.d-none').forEach(_ => _.classList.toggle('d-md-block'))
    document.querySelector('.content').classList.toggle('toggled')
    const sidebarToggled = this.element.classList.contains('toggled')
    fetchAPI(Routes.schematicsPreferencesEn(), 'PUT', { preferences: { sidebar_toggled: sidebarToggled } })
  }
}
