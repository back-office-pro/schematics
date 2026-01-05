/*
 * Copyright © 2025 Dev & Software. All rights reserved.
 *
 * THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
 * REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
 * NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
 * LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.
 */

import { Controller } from '@hotwired/stimulus'

/* global Turbo, fetch, localStorage, Response */

export default class extends Controller {
  visit ({ target, params: { href } }) {
    if (!target.closest('a, input, button, .btn-group, .form-check')) {
      Turbo.visit(href)
    }
  }

  disableWith ({ target }) {
    target.closest('a').classList.add('disabled')
  }

  submitForm ({ target }) {
    target.form.requestSubmit()
  }

  fetchAPI (url, method = 'GET', data) {
    const syncUrl = `sync:${btoa(url)}`
    if (navigator.onLine) {
      localStorage.removeItem(syncUrl)
      return fetch(url, {
        method,
        body: data && JSON.stringify(data),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name=csrf-token]')?.content,
          Accept: 'application/json'
        }
      })
    } else {
      if (method !== 'GET') {
        localStorage.setItem(syncUrl, JSON.stringify(Array.from(arguments)))
      }
      return new Response('null')
    }
  }

  debounce (callback, delay = 200) {
    let timer
    return (...args) => {
      clearTimeout(timer)
      timer = setTimeout(() => callback.apply(this, args), delay)
    }
  }
}
