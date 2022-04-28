import { Controller } from '@hotwired/stimulus'

/* global Turbo, fetch */

export default class extends Controller {
  visit ({ target, params: { href } }) {
    if (!target.closest('a, .btn-group')) {
      Turbo.visit(href)
    }
  }

  fetchAPI (url, method = 'GET', data) {
    const options = {
      method,
      body: data && JSON.stringify(data),
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json'
      }
    }
    return fetch(url, options)
  }
}
