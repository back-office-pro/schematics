import BulkActionController from 'controllers/bulk_action_controller'

/* global Turbo, routes */

export default class extends BulkActionController {
  async submit () {
    this.buttonTarget.disabled = true
    const params = { comparison: { ids: this.ids() } }
    const response = await this.fetchAPI(`${window.location.pathname}/${routes.comparisons}`, 'POST', params)
    Turbo.visit(response.headers.get('Location'))
  }
}
