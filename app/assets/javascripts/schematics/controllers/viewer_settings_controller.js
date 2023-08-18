import ApplicationController from 'controllers/application_controller'

/* global routes */

export default class extends ApplicationController {
  toggleColumn ({ target: { id, checked } }) {
    document.querySelectorAll(`.${id}`).forEach(element => {
      element.classList.add('animate__animated')
      element.classList.toggle('d-none')
    })
    this.fetchAPI(routes.preferences, 'PUT', { preferences: { [id]: checked } })
  }

  async switchLayout ({ target, params: { viewer, preference } }) {
    await this.fetchAPI(routes.preferences, 'PUT', { preferences: { [preference]: viewer } })
    target.closest('form').requestSubmit()
  }
}
