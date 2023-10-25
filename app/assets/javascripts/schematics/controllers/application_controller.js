import { Controller } from '@hotwired/stimulus'

/* global Turbo, fetch */

export default class extends Controller {
  visit ({ target, params: { href } }) {
    if (!target.closest('a, input, button, .btn-group, .form-check')) {
      Turbo.visit(href)
    }
  }

  fetchAPI (url, method = 'GET', data) {
    const options = {
      method,
      body: data && JSON.stringify(data),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name=csrf-token]').content,
        Accept: 'application/json'
      }
    }
    return fetch(url, options)
  }

  debounce (callback, delay = 200) {
    let timer
    return (...args) => {
      clearTimeout(timer)
      timer = setTimeout(() => callback.apply(this, args), delay)
    }
  }
}
