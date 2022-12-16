import 'chartkick'
import 'Chart.bundle'
import { application } from 'controllers/application'
import Pagy from 'pagy-module'
import Rollbar from 'rollbar'

/* global environment, mapsApiKey, rollbarClientKey, Chartkick */

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

const defaultErrorHandler = application.handleError.bind(application)
const rollbar = new Rollbar({
  accessToken: rollbarClientKey,
  captureUncaught: true,
  captureUnhandledRejections: true,
  environment
})

application.handleError = (error, message, detail = {}) => {
  defaultErrorHandler(error, message, detail)
  rollbar.error(error)
}

Chartkick.configure({ language: document.documentElement.lang, mapsApiKey })
document.addEventListener('turbo:load', Pagy.init)
document.addEventListener('scroll', setNavbarScrolled)
document.addEventListener('turbo:before-fetch-request', setTurboHeaders)
document.addEventListener('turbo:before-fetch-request', animateTurboFrame)
document.addEventListener('turbo:before-cache', setTurboNonces)
