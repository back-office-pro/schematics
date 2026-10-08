import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  static get targets () {
    return ['digit']
  }

  connect () {
    this.digitTargets[0].focus()
  }

  input (event) {
    const { target, data } = event
    const { value } = target
    if (isNaN(value) || data === null) {
      target.value = ''
    } else {
      this.navigateRight(event)
    }
  }

  async paste () {
    const digits = (await navigator.clipboard.readText()).trim().split('')
    this
      .digitTargets
      .slice(0, digits.length)
      .forEach((target, index) => {
        target.value = digits[index]
        target.focus()
      })
  }

  navigateLeft ({ target }) {
    this.digitTargets[this.digitTargets.indexOf(target) - 1]?.focus()
  }

  navigateRight ({ target }) {
    this.digitTargets[this.digitTargets.indexOf(target) + 1]?.focus()
  }
}
