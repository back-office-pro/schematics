import { render, register } from '../timeago.js/esm/index'
import fr from '../timeago.js/esm/lang/fr'

register('fr', fr)

document.addEventListener('turbolinks:load', function () {
  const { lang } = document.querySelector('html')
  document
    .querySelectorAll('.timeago')
    .forEach(_ => render(_, lang))
})
