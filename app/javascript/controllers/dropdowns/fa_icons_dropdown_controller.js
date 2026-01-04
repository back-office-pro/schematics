import DropdownController from 'controllers/dropdown_controller'

export default class extends DropdownController {
  get options () {
    return Object.assign(super.options, {
      render: {
        option: ({ value }, escape) => `<i class='fa-solid fa-${escape(value.replace(/_/g, '-'))}'></i>`,
        item: ({ value }, escape) => `<i class='fa-solid fa-${escape(value.replace(/_/g, '-'))}'></i>`
      }
    })
  }
}
