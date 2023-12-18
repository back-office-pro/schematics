import ApplicationController from 'controllers/application_controller'

/* global routes */

export default class extends ApplicationController {
  toggleColumn ({ target: { id, checked } }) {
    document.querySelectorAll(`.${id}`).forEach(element => {
      element.classList.add('animate__animated')
      element.classList.toggle('d-none')
    })
    this.fetchAPI(routes.preferences, 'PUT', { user: { preferences: { [id]: checked } } })
  }

  async switchLayout ({ params: { viewer, preference } }) {
    const data = { user: { preferences: { [preference]: viewer } } }
    await this.fetchAPI(routes.preferences, 'PUT', data)
    document.getElementById('filters').requestSubmit()
  }
}
