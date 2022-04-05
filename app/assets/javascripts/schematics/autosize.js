//= require autosize/dist/autosize

/* global autosize */

document.addEventListener('turbolinks:load', function () {
  document
    .querySelectorAll('textarea')
    .forEach(_ => autosize(_))
})
