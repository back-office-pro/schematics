import { Controller } from '@hotwired/stimulus'

/* global fetch */

export default class extends Controller {
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
