//= require file-saver/dist/FileSaver

/* global Stimulus, fetchAPI, Blob, saveAs */

window.GenerateFileInBackgroundController = class extends Stimulus.Controller {
  static get targets () {
    return ['button', 'loading']
  }

  toggleButton (loadingText) {
    this.buttonTarget.disabled = !this.buttonTarget.disabled
    this.loadingTarget.textContent = loadingText
    this.buttonTarget.querySelectorAll('.icon').forEach(_ => _.classList.toggle('d-none'))
    this.buttonTarget.querySelectorAll('.text').forEach(_ => _.classList.toggle('d-lg-inline'))
  }

  async run (event) {
    event.preventDefault()
    let timer = 0
    const loadingText = this.loadingTarget.textContent
    this.toggleButton(loadingText)
    const { allPages } = event.target.dataset
    const response = await fetchAPI(this.buildUrl(allPages))
    const fingerprint = await response.text()
    const throttleWait = 10
    const interval = setInterval(async () => {
      if (!allPages || timer % throttleWait === 0) {
        const res = await fetchAPI(this.buildUrl(allPages, fingerprint))
        const data = await res.arrayBuffer()
        if (data.byteLength) {
          clearInterval(interval)
          const filename = res.headers.get('Content-Disposition').match(/filename="(.*)";/)[1]
          const blob = new Blob([data], { type: `${this.data.get('contentType')};charset=utf-8` })
          saveAs(blob, filename)
          return this.toggleButton(loadingText)
        }
      }
      timer++
      this.loadingTarget.textContent = `${loadingText} (${timer})`
    }, 1000)
  }

  buildUrl (allPages, fingerprint) {
    const searchParams = new URLSearchParams(window.location.search)
    if (fingerprint != null) {
      searchParams.set('fingerprint', fingerprint)
    }
    if (allPages) {
      searchParams.set('all_pages', true)
    }
    return `${window.location.pathname}.${this.extension}?${searchParams}`
  }

  get extension () {
    return this.data.get('contentType').split('/')[1]
  }
}
