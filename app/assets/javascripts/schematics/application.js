import 'chartkick'
import 'Chart.bundle'
import '@client-side-validations/simple-form'
import Pagy from 'pagy-module'

/* global mapsApiKey, Chartkick */

const setNavbarScrolled = () => {
  document
    .querySelector('nav.navbar')
    ?.classList
    ?.toggle('scrolled', window.scrollY > 25)
}

const setTurboHeaders = (event) => {
  const nonce = document.querySelector('meta[name="csp-nonce"]')?.content
  event.detail.fetchOptions.headers['Turbo-Referrer'] = window.location.href
  event.detail.fetchOptions.headers['X-Turbo-Nonce'] = nonce
}

const setTurboNonces = () => {
  document.querySelectorAll('script[nonce]').forEach(element => {
    element.setAttribute('nonce', element.nonce)
  })
}

const animateTurboFrame = ({ target }) => {
  target.classList.add('animate__fadeOut')
  target.addEventListener('animationend', () => {
    target.classList.remove('animate__fadeOut')
    target.classList.add('animate__fadeIn')
  })
}

Chartkick.configure({ language: document.documentElement.lang, mapsApiKey })
document.addEventListener('turbo:load', Pagy.init)
document.addEventListener('scroll', setNavbarScrolled)
document.addEventListener('turbo:before-fetch-request', setTurboHeaders)
document.addEventListener('turbo:before-fetch-request', animateTurboFrame)
document.addEventListener('turbo:before-cache', setTurboNonces)
