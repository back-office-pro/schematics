import ApplicationController from 'controllers/application_controller'

/* global FileReader, Image */

export default class extends ApplicationController {
  static get targets () {
    return ['container', 'input']
  }

  preview () {
    this.containerTarget.replaceChildren(...this.files.map(this.#readAndCreateImage))
  }

  get files () {
    return [...this.inputTarget.files].filter((file) => /\.(jpe?g|png|gif)$/i.test(file.name))
  }

  #readAndCreateImage (file) {
    const reader = new FileReader()
    const image = new Image()
    image.height = 100
    image.title = file.name
    image.classList.add('animate__animated', 'animate__zoomIn', 'rounded', 'me-2', 'mb-2')
    reader.addEventListener('load', () => { image.src = reader.result })
    reader.readAsDataURL(file)
    return image
  }
}
