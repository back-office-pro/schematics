import 'trix'
import '@rails/actiontext'
import '@hotwired/turbo-rails'
import 'controllers'
import 'chartkick'
import 'Chart.bundle'
import { application } from 'controllers/application'
import { Crisp } from 'crisp-sdk-web'
import Rollbar from 'rollbar'

/* global matchMedia, environment, crispClientId, mapsAPIKey, rollbarClientKey, Chartkick, I18n, Trix, Pagy */

const setTheme = () => {
  if (matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.classList.add('dark-mode')
    document.documentElement.setAttribute('data-bs-theme', 'dark')
  } else {
    document.documentElement.classList.remove('dark-mode')
    document.documentElement.setAttribute('data-bs-theme', 'light')
  }
}

const setNavbarScrolled = () => {
  document.querySelector('nav.navbar')?.classList.toggle('bg-opacity-75', window.scrollY > 25)
}

const startViewTransition = ({ detail }) => {
  if (document.startViewTransition) {
    const originalRender = detail.render
    detail.render = (currentElement, newElement) => {
      document.startViewTransition(() => originalRender(currentElement, newElement))
    }
  }
}

const redirectOnFrameMissing = (event) => {
  if (event.detail.response.redirected) {
    event.preventDefault()
    event.detail.visit(event.detail.response)
  }
}

const defaultErrorHandler = application.handleError.bind(application)
const rollbar = new Rollbar({
  accessToken: rollbarClientKey,
  captureUncaught: true,
  captureUnhandledRejections: true,
  captureIp: 'anonymize',
  environment
})

application.handleError = (error, message, detail = {}) => {
  defaultErrorHandler(error, message, detail)
  rollbar.error(error)
}

Crisp.configure(crispClientId, { autoload: false })
Chartkick.configure({ language: document.documentElement.lang, mapsAPIKey })

document.addEventListener('turbo:load', Pagy.init)
document.addEventListener('turbo:before-frame-render', startViewTransition)
document.addEventListener('turbo:frame-missing', redirectOnFrameMissing)
document.addEventListener('scroll', setNavbarScrolled)
matchMedia('(prefers-color-scheme: dark)').addEventListener('change', setTheme)

if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/service-worker.js', { scope: '/' })
}

for (const [key, value] of Object.entries(I18n.trix)) {
  Trix.config.lang[key] = value
}
