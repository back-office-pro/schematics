import ApplicationController from '../schematics/controllers/application_controller'

export default class extends ApplicationController {
  static get targets () {
    return ['resource', 'form']
  }

  connect () {
    this.formTarget.addEventListener('ajax:success', this.success.bind(this))
    this.formTarget.addEventListener('ajax:error', this.error.bind(this))
  }

  disconnect () {
    this.formTarget.removeEventListener('ajax:success', this.success.bind(this))
    this.formTarget.removeEventListener('ajax:error', this.error.bind(this))
  }

  toggle (event) {
    event?.preventDefault()
    this.resourceTarget.classList.toggle('d-none')
    this.formTarget.classList.toggle('d-none')
    this.formTarget.reset()
    this.clearErrors()
  }

  success ({ detail: [data] }) {
    this.clearErrors()
    this.toggle()
    this.resourceTarget.innerText = Object.values(data)[0]
    this.blink()
  }

  error ({ detail: [errors] }) {
    this.clearErrors()
    this.input.classList.add('is-invalid')
    for (const key in errors) {
      const template = `<div class='invalid-feedback animate__animated animate__slideInDown'>${errors[key]}</div>`
      this.input.insertAdjacentHTML('afterend', template)
    }
  }

  clearErrors () {
    if (this.input.nextSibling) {
      this.input.classList.remove('is-invalid')
      this.input.parentNode.removeChild(this.input.nextSibling)
    }
  }

  blink () {
    this.resourceTarget.classList.remove('animate__flash')
    void this.resourceTarget.offsetWidth // eslint-disable-line no-void
    this.resourceTarget.classList.add('animate__flash')
  }

  get input () {
    return this.formTarget.querySelector('.form-control')
  }
}
