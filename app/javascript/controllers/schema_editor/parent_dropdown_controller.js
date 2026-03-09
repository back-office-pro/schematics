/*
 * Copyright © 2025 Dev & Software. All rights reserved.
 *
 * THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
 * REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
 * NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
 * LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.
 */

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
