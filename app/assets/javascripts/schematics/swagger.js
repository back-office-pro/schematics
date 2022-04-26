//= require swagger-ui-dist/swagger-ui-bundle

/* global SwaggerUIBundle, Routes */

document.addEventListener('turbo:load', function () {
  const domNode = document.getElementById('swagger-ui')
  if (domNode != null) {
    SwaggerUIBundle({
      url: Routes.schematicsOpenApi(),
      domNode,
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
      ],
      plugins: [
        SwaggerUIBundle.plugins.DownloadUrl
      ]
    })
  }
})
