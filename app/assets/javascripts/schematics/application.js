import 'trix'
import '@rails/actiontext'
import '@hotwired/turbo-rails'
import 'controllers'
import 'chartkick'
import 'Chart.bundle'
import { application } from 'controllers/application'
import { Crisp } from 'crisp-sdk-web'
import Pagy from 'pagy-module'
import Rollbar from 'rollbar'

/* global matchMedia, environment, crispClientId, mapsApiKey, rollbarClientKey, Chartkick */

const setTheme = () => {
  document
    .documentElement
    .setAttribute('data-bs-theme', matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
}

const setNavbarScrolled = () => {
  document
    .querySelector('nav.navbar')
    ?.classList
    ?.toggle('bg-opacity-75', window.scrollY > 25)
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

Crisp.configure(crispClientId, { autoload: false })
Chartkick.configure({ language: document.documentElement.lang, mapsApiKey })

document.addEventListener('turbo:load', Pagy.init)
document.addEventListener('scroll', setNavbarScrolled)
document.addEventListener('turbo:before-fetch-request', animateTurboFrame)
matchMedia('(prefers-color-scheme: dark)').addEventListener('change', setTheme)
