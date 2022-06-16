import ApplicationController from './application_controller'
import Tribute from 'tributejs'
import Trix from 'trix'
import { usersEn, searchEn } from 'routes'

export default class extends ApplicationController {
  connect () {
    this.tribute = new Tribute({ collection: this.options })
    this.tribute.attach(this.element)
    this.tribute.range.pasteHtml = this.pasteHtml.bind(this)
    this.element.addEventListener('tribute-replaced', this.replaced)
  }

  disconnect () {
    this.tribute.detach(this.element)
  }

  replaced ({ detail: { item: { original: { attachableSgid, Mention } } } }) {
    const attachment = new Trix.Attachment({ sgid: attachableSgid, content: Mention })
    this.editor.insertAttachment(attachment)
    this.editor.insertString(' ')
  }

  async fetchUsers (text, callback) {
    const searchParams = new URLSearchParams()
    searchParams.set('filter[full_name]', text)
    searchParams.set('mention', true)
    const url = `${usersEn()}?${searchParams}`
    const response = await this.fetchAPI(url)
    const users = await response.json()
    callback(users)
  }

  async search (text, callback) {
    const url = searchEn(text)
    const response = await this.fetchAPI(url)
    const results = await response.json()
    callback(results)
  }

  pasteHtml (_html, startPosition, endPosition) {
    const position = this.editor.getPosition()
    this.editor.setSelectedRange([position - (endPosition - startPosition), position])
    this.editor.deleteInDirection('backward')
  }

  get options () {
    return [
      {
        trigger: '@',
        allowSpaces: true,
        noMatchTemplate: '',
        menuItemLimit: 5,
        menuShowMinLength: 2,
        lookup: 'fullName',
        values: this.fetchUsers.bind(this)
      },
      {
        trigger: '#',
        allowSpaces: true,
        noMatchTemplate: '',
        menuItemLimit: 5,
        menuShowMinLength: 2,
        lookup: 'Metadata.descriptor',
        values: this.search.bind(this)
      }
    ]
  }

  get editor () {
    return this.element.editor
  }
}
