import { Controller } from '../../@hotwired/stimulus/dist/stimulus'
import { saveAs } from '../../file-saver-es/src/FileSaver'

/* global fetchAPI, Blob */

export class GenerateFileInBackgroundController extends Controller {
  static get targets () {
    return ['button', 'loading']
  }

  static get values () {
    return { contentType: String }
  }

  toggleButton (loadingText) {
    this.buttonTarget.disabled = !this.buttonTarget.disabled
    this.loadingTarget.textContent = loadingText
    this.buttonTarget.querySelectorAll('.icon').forEach(_ => _.classList.toggle('d-none'))
    this.buttonTarget.querySelectorAll('.text').forEach(_ => _.classList.toggle('d-lg-inline'))
  }

  async run ({ params: { allPages } }) {
    let timer = 0
    const loadingText = this.loadingTarget.textContent
    this.toggleButton(loadingText)
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
          const blob = new Blob([data], { type: `${this.contentTypeValue};charset=utf-8` })
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
    return this.contentTypeValue.split('/')[1]
  }
}
