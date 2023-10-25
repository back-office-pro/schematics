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

const startViewTransition = ({ detail }) => {
  if (document.startViewTransition) {
    const originalRender = detail.render
    detail.render = (currentElement, newElement) => {
      document.startViewTransition(() => originalRender(currentElement, newElement))
    }
  }
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
document.addEventListener('turbo:before-render', startViewTransition)
document.addEventListener('turbo:before-frame-render', startViewTransition)
document.addEventListener('scroll', setNavbarScrolled)
matchMedia('(prefers-color-scheme: dark)').addEventListener('change', setTheme)
