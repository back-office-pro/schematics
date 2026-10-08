import SortableController from 'controllers/sortable_controller'

export default class extends SortableController {
  static get values () {
    return Object.assign(super.values, {
      root: { type: String },
      attribute: { type: String }
    })
  }

  save (_) {}

  async #move ({ from, to, item, clone }) {
    const value = to.getAttribute('data-kanban-group-value')
    const id = item.getAttribute('data-id')
    const data = { [this.rootValue]: { [this.attributeValue]: value } }
    const response = await this.fetchAPI(`${window.location.pathname}/${id}`, 'PUT', data)
    if (!response.ok) {
      from.append(item)
      clone.remove()
    }
  }

  get options () {
    return Object.assign(super.options, {
      onAdd: this.#move.bind(this),
      sort: false
    })
  }
}
