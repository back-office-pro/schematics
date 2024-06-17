/* global importScripts, workbox, Response */

importScripts('https://storage.googleapis.com/workbox-cdn/releases/7.1.0/workbox-sw.js')

const { warmStrategyCache } = workbox.recipes
const { CacheFirst, NetworkFirst } = workbox.strategies
const { registerRoute, Route, setCatchHandler } = workbox.routing

const strategy = new CacheFirst()
const urls = ['/offline.html']

warmStrategyCache({ urls, strategy })

setCatchHandler(async ({ event }) => {
  switch (event.request.destination) {
    case 'document':
      return strategy.handle({ event, request: urls[0] })
    default:
      return Response.error()
  }
})

registerRoute(
  new Route(({ request }) => request.destination === 'document' || request.destination === '',
    new NetworkFirst({ cacheName: 'documents' }))
)

registerRoute(
  new Route(({ request }) => request.destination === 'script' || request.destination === 'style',
    new CacheFirst({ cacheName: 'assets-styles-and-scripts' }))
)

registerRoute(
  new Route(({ request }) => request.destination === 'image',
    new CacheFirst({ cacheName: 'assets-images' }))
)

registerRoute(
  new Route(({ request }) => request.destination === 'font',
    new CacheFirst({ cacheName: 'assets-fonts' }))
)
