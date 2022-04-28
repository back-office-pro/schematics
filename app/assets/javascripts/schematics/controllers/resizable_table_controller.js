import ApplicationController from './application_controller'
import { ResizableTableColumns } from '@validide/resizable-table-columns'

export default class extends ApplicationController {
  initialize () {
    new ResizableTableColumns(this.element, { minWidth: 100 }) // eslint-disable-line no-new
  }
}
