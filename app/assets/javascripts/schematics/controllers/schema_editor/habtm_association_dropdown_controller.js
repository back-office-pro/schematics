import AssociationDropdownController from 'controllers/schema_editor/association_dropdown_controller'
import pluralize from 'pluralize'

export default class extends AssociationDropdownController {
  get collection () {
    return Array
      .from(this.inputs)
      .map(_ => pluralize(_.value))
      .map(value => ({ value, text: value }))
  }
}
