import ApplicationController from 'controllers/application_controller'
import { Crisp } from 'crisp-sdk-web'

export default class extends ApplicationController {
  open () {
    Crisp.chat.open()
  }
}
