import ApplicationController from 'controllers/application_controller'

/* global open */

export default class extends ApplicationController {
  static get targets () {
    return ['button', 'loading']
  }

  static get values () {
    return { extension: String, url: String }
  }

  connect () {
    if (this.urlValue !== '') {
      open(this.urlValue)
    }
  }

  run ({ params: { allPages } }) {
    let timer = 1
    const loadingText = this.loadingTarget.textContent
    this.buttonTarget.disabled = true
    this.fetchAPI(this.url(allPages))
    setInterval(() => { this.loadingTarget.textContent = `${loadingText} (${timer++})` }, 1000)
  }

  url (allPages) {
    const searchParams = new URLSearchParams(window.location.search)
    if (allPages) {
      searchParams.set('all_pages', true)
    }
    return `${window.location.pathname}.${this.extensionValue}?${searchParams}`
  }
}
