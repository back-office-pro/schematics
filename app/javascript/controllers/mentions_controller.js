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

import ApplicationController from 'controllers/application_controller'
import Tribute from 'tributejs'
import Trix from 'trix'

/* global routes */

export default class extends ApplicationController {
  connect () {
    this.tribute = new Tribute(this.options)
    this.tribute.attach(this.element)
    this.tribute.range.pasteHtml = this.#pasteHTML.bind(this)
    this.element.addEventListener('tribute-replaced', this.#replaced.bind(this))
  }

  disconnect () {
    this.tribute.detach(this.element)
  }

  #replaced ({ detail: { item: { original } } }) {
    if (original._metadata) {
      const { sgid, descriptor, icon, url } = original._metadata
      const attachment = new Trix.Attachment({ sgid, content: this.#template(descriptor, icon, url) })
      this.editor.insertAttachment(attachment)
    } else {
      this.editor.insertString(original.value)
    }
    this.editor.insertString(' ')
  }

  async #fetchUsers (text, callback) {
    const searchParams = new URLSearchParams()
    searchParams.set('filter[full_name]', text)
    searchParams.set('metadata', true)
    const url = [routes.users, searchParams].join('?')
    const response = await this.fetchAPI(url)
    const users = await response.json()
    callback(users)
  }

  async #search (query, callback) {
    const response = await this.fetchAPI(routes.searches, 'POST', { autocompletion: { query } })
    const results = await response.json()
    callback(results)
  }

  async #fetchEmojis (_, callback) {
    if (this.emojis == null) {
      const response = await this.fetchAPI(routes.emojis)
      const results = await response.json()
      this.emojis = Object.entries(results).flatMap(this.#formatEmojis)
    }
    callback(this.emojis)
  }

  #pasteHTML (_html, startPosition, endPosition) {
    const position = this.editor.getPosition()
    this.editor.setSelectedRange([position - (endPosition - startPosition), position])
    this.editor.deleteInDirection('backward')
  }

  #template (descriptor, icon, url) {
    if (url.startsWith(routes.users)) {
      return `<i class="fa fa-at me-1"></i><a href="${url}" class="fw-bold">${descriptor}</a>`
    } else {
      return `<i class="fa fa-${icon} me-1"></i><a href="${url}">${descriptor}</a>`
    }
  }

  #formatEmojis ([key, values]) {
    return values.map(value => ({ key: `${value} :${key}:`, value }))
  }

  get options () {
    return {
      allowSpaces: true,
      menuItemLimit: 5,
      menuShowMinLength: 2,
      noMatchTemplate: () => null,
      loadingItemTemplate: () => null,
      collection: [
        {
          trigger: '@',
          lookup: 'full_name',
          values: this.debounce(this.#fetchUsers),
          containerClass: 'tribute-container list-group list-group-striped shadow-sm',
          itemClass: 'list-group-item list-group-item-action p-2 border-0 text-start text-truncate'
        },
        {
          trigger: '#',
          lookup: ({ _metadata }) => _metadata?.descriptor,
          values: this.debounce(this.#search),
          containerClass: 'tribute-container list-group list-group-striped shadow-sm',
          itemClass: 'list-group-item list-group-item-action p-2 border-0 text-start text-truncate'
        },
        {
          trigger: ':',
          values: this.debounce(this.#fetchEmojis),
          containerClass: 'tribute-container list-group list-group-striped shadow-sm',
          itemClass: 'list-group-item list-group-item-action p-2 border-0 text-start text-truncate'
        }
      ]
    }
  }

  get editor () {
    return this.element.editor
  }
}
