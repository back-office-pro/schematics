import DropdownController from 'controllers/dropdown_controller'

export default class extends DropdownController {
  static get values () {
    return { selected: String }
  }

  get options () {
    return Object.assign(super.options, {
      items: [this.selectedValue],
      maxOptions: this.colors.length,
      options: this.colors.map(value => ({ value, text: value })),
      render: {
        option: ({ value }, escape) => `<div><div class='bg-${escape(value)} rounded p-3'></div></div>`,
        item: ({ value }, escape) => `<div class='bg-${escape(value)}'></div>`
      }
    })
  }

  get colors () {
    return ['primary', 'secondary', 'success', 'danger', 'warning']
  }
}
