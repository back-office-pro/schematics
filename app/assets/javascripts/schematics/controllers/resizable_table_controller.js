import { Controller } from '../../@hotwired/stimulus/dist/stimulus'
import { ResizableTableColumns } from '../../@validide/resizable-table-columns/dist/js/es6/index'

export default class extends Controller {
  initialize () {
    new ResizableTableColumns(this.element, { minWidth: 100 }) // eslint-disable-line no-new
  }
}
