//= require autosize/dist/autosize

document.addEventListener('turbolinks:load', function () {
  document
    .querySelectorAll('textarea')
    .forEach(_ => autosize(_))
})
