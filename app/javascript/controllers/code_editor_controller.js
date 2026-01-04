import ApplicationController from 'controllers/application_controller'
import { editor } from 'monaco-editor'

export default class extends ApplicationController {
  static get targets () {
    return ['input', 'container']
  }

  static get values () {
    return {
      initialValue: String,
      language: String,
      readonly: { type: Boolean, default: false }
    }
  }

  initialize () {
    this.editor = editor.create(this.containerTarget, this.options)
    this.editor.getModel().onDidChangeContent(this.#setInputValue.bind(this))
    this.#setInputValue()
  }

  #setInputValue () {
    this.inputTarget.value = this.editor.getValue()
  }

  get options () {
    return {
      value: this.initialValueValue,
      language: this.languageValue,
      readOnly: this.readonlyValue,
      minimap: { enabled: false },
      automaticLayout: true,
      scrollBeyondLastLine: false
    }
  }
}
