//= require stimulus/dist/stimulus.umd
//= require regenerator-runtime/runtime

/* global Stimulus, fetch */

window.application = Stimulus.Application.start()
window.fetchAPI = (url, method = 'GET', data) => {
  const csrfToken = document.querySelector("[name='csrf-token']").content
  const options = {
    method: method,
    body: data && JSON.stringify(data),
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json',
      Accept: 'application/json'
    }
  }
  return fetch(url, options)
}
