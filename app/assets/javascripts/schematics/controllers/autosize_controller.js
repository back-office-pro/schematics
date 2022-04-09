import ApplicationController from './application_controller'
import autosize from '../../autosize/dist/autosize.esm'

export default class extends ApplicationController {
  connect () {
    autosize(this.element)
  }
}
