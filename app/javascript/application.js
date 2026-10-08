import 'trix'
import '@rails/actiontext'
import '@hotwired/turbo-rails'
import 'controllers'
import 'chartkick'
import 'Chart.bundle'

/* global matchMedia, mapsAPIKey, Chartkick, I18n, Trix, Pagy */

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
