import AssociationDropdownController from 'controllers/schema_editor/association_dropdown_controller'

export default class extends AssociationDropdownController {
  get entityNameElement () {
    return document
      .querySelector(`div[data-bs-target="#${this.modalId}"]`)
      .closest('.schema-editor-entity')
      .querySelector('.entity-name')
  }

  get entityChildrenNameElements () {
    return Array
      .from(document.querySelectorAll('select[data-controller="schema-editor--parent-dropdown"] option[selected]'))
      .map(_ => _.closest('.schema-editor-entity')?.querySelector('.entity-name'))
  }

  get deniedNames () {
    return this
      .entityChildrenNameElements
      .filter(Boolean)
      .concat(this.entityNameElement)
      .map(_ => _.value)
  }

  get modalId () {
    return this
      .element
      .closest('.modal')
      .getAttribute('id')
  }

  get collection () {
    return super
      .collection
      .filter(_ => !this.deniedNames.includes(_.value))
  }
}
