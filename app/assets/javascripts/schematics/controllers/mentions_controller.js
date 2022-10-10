import ApplicationController from 'controllers/application_controller'
import Tribute from 'tributejs'
import Trix from 'trix'

/* global routes */

export default class extends ApplicationController {
  connect () {
    this.tribute = new Tribute(this.options)
    this.tribute.attach(this.element)
    this.tribute.range.pasteHtml = this.pasteHtml.bind(this)
    this.element.addEventListener('tribute-replaced', this.replaced.bind(this))
  }

  disconnect () {
    this.tribute.detach(this.element)
  }

  replaced ({ detail: { item: { original: { Metadata: { sgid, descriptor, icon, url } } } } }) {
    const attachment = new Trix.Attachment({ sgid, content: this.template(descriptor, icon, url) })
    this.editor.insertAttachment(attachment)
    this.editor.insertString(' ')
  }

  async fetchUsers (text, callback) {
    const searchParams = new URLSearchParams()
    searchParams.set('filter[full_name]', text)
    searchParams.set('metadata', true)
    const url = [routes.users, searchParams].join('?')
    const response = await this.fetchAPI(url)
    const users = await response.json()
    callback(users)
  }

  async search (text, callback) {
    const url = [routes.searches, text].join('/')
    const response = await this.fetchAPI(url)
    const results = await response.json()
    callback(results)
  }

  pasteHtml (_html, startPosition, endPosition) {
    const position = this.editor.getPosition()
    this.editor.setSelectedRange([position - (endPosition - startPosition), position])
    this.editor.deleteInDirection('backward')
  }

  template (descriptor, icon, url) {
    return `<i class="fa fa-${icon} me-2"></i><a href="${url}">${descriptor}</a>`
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
          lookup: 'fullName',
          values: this.fetchUsers.bind(this)
        },
        {
          trigger: '#',
          lookup: ({ Metadata: { descriptor } }) => descriptor,
          values: this.search.bind(this)
        }
      ]
    }
  }

  get editor () {
    return this.element.editor
  }
}
