import BulkActionController from 'controllers/bulk_action_controller'

/* global routes */

export default class extends BulkActionController {
  get params () {
    return { comparison: { ids: this.ids() } }
  }

  get url () {
    return `${window.location.pathname}/${routes.comparisons}`
  }
}
