document.addEventListener('turbolinks:request-start', function (event) {
  const nonce = document.querySelector('meta[name="csp-nonce"]').content
  event.data.xhr.setRequestHeader('X-Turbolinks-Nonce', nonce)
})

document.addEventListener('turbolinks:before-cache', function () {
  document.querySelectorAll('script[nonce]').forEach(element => {
    element.setAttribute('nonce', element.nonce)
  })
})
