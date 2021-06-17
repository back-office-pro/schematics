//= require file-saver/dist/FileSaver

/* global Stimulus, fetchAPI, Blob, saveAs, I18n */

window.GenerateAsyncFileController = class extends Stimulus.Controller {
  static get targets () {
    return ['text', 'icon']
  }

  async call (event) {
    event.preventDefault()
    const text = this.textTarget.textContent
    const icon = this.iconTarget.innerHTML
    let timer = 0
    this.textTarget.textContent = I18n.generate_async_file.pending
    this.iconTarget.innerHTML = '<i class="fa fa-spinner fa-spin fa-fw"></i>'
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
        this.textTarget.textContent = text
        this.iconTarget.innerHTML = icon
      } else {
        timer++
        this.textTarget.textContent = `${I18n.generate_async_file.pending} (${timer})`
      }
    }, 1000)
  }

  get extension () {
    return this.data.get('contentType').split('/')[1]
  }
}
