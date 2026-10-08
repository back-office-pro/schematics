import DropdownController from 'controllers/dropdown_controller'

export default class extends DropdownController {
  get options () {
    return Object.assign(super.options, {
      render: {
        option: ({ value }, escape) => `<div><div class='bg-${escape(value)} rounded p-3'></div></div>`,
        item: ({ value }, escape) => `<div class='bg-${escape(value)}'></div>`
      }
    })
  }
}
