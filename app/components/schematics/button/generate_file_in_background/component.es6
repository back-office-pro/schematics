//= require file-saver/dist/FileSaver

/* global Stimulus, fetchAPI, Blob, saveAs */

window.GenerateFileInBackgroundController = class extends Stimulus.Controller {
  static get targets () {
    return ['loading']
  }

  toggleButton (loadingText) {
    this.element.disabled = !this.element.disabled
    this.loadingTarget.textContent = loadingText
    this.element.querySelectorAll('.icon').forEach(_ => _.classList.toggle('d-none'))
    this.element.querySelectorAll('.text').forEach(_ => _.classList.toggle('d-lg-inline'))
  }

  async run (event) {
    event.preventDefault()
    let timer = 0
    const loadingText = this.loadingTarget.textContent
    this.toggleButton(loadingText)
    const response = await fetchAPI(this.data.get('url'))
    const fingerprint = await response.text()
    const interval = setInterval(async () => {
      const res = await fetchAPI(`${this.data.get('url')}?fingerprint=${fingerprint}`)
      const data = await res.arrayBuffer()
      if (data.byteLength) {
        clearInterval(interval)
        const filename = res.headers.get('Content-Disposition').match(/filename="(.*)";/)[1]
        const blob = new Blob([data], { type: `${this.data.get('contentType')};charset=utf-8` })
        saveAs(blob, filename)
        this.toggleButton(loadingText)
      } else {
        timer++
        this.loadingTarget.textContent = `${loadingText} (${timer})`
      }
    }, 1000)
  }

  get extension () {
    return this.data.get('contentType').split('/')[1]
  }
}
