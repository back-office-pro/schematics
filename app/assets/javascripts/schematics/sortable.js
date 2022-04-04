//= require sortablejs/Sortable

/* global Sortable */

document.addEventListener('turbolinks:load', function () {
  document
    .querySelectorAll('tbody.sortable')
    .forEach(Sortable.create)
})
