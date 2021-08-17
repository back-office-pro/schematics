/* global Stimulus, fetchAPI */

window.ViewerSettings = class extends Stimulus.Controller {
  keepOpened (e) {
    e.stopPropagation()
  }

  toggleColumn (e) {
    const { id, checked } = e.target
    document.querySelectorAll(`.${id}`).forEach(element => {
      element.classList.toggle('d-none')
    })
    fetchAPI('/preferences', 'PUT', { preferences: { [id]: checked } })
  }
}
