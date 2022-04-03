/* global timeago */

document.addEventListener('turbolinks:load', function () {
  const { lang } = document.querySelector('html')
  document
    .querySelectorAll('.timeago')
    .forEach(_ => timeago.render(_, lang))
})
