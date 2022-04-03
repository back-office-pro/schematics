import Sortable from '../sortablejs/modular/sortable.esm'

document.addEventListener('turbolinks:load', function () {
  document
    .querySelectorAll('tbody')
    .forEach(Sortable.create)
})
