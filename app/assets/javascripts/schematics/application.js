import 'chartkick'
import 'Chart.bundle'
import '@client-side-validations/simple-form'
import Pagy from 'pagy-module'

/* global mapsApiKey, Chartkick */

Chartkick.configure({ language: document.documentElement.lang, mapsApiKey })
document.addEventListener('turbo:load', Pagy.init)
document.addEventListener('scroll', function () {
  const navbar = document.querySelector('nav.navbar')
  if (navbar != null) {
    window.scrollY > 25 ? navbar.classList.add('scrolled') : navbar.classList.remove('scrolled')
  }
})
