import { ResizableTableColumns } from '../@validide/resizable-table-columns/dist/js/es6/index'

document.addEventListener('turbolinks:load', function () {
  document
    .querySelectorAll('table.resizable')
    .forEach(_ => new ResizableTableColumns(_, { minWidth: 100 }))
})
