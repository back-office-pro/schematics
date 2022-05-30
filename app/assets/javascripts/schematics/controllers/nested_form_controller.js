import NestedForm from 'stimulus-rails-nested-form'
import ClientSideValidations from '@client-side-validations/client-side-validations'

export default class extends NestedForm {
  add (e) {
    super.add(e)
    ClientSideValidations.reset(e.target.closest('form'))
  }
}
