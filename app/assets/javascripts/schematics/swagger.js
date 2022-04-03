import SwaggerUIBundle from '../@kensingtontech/swagger-ui/dist/swagger-ui-es-bundle'

/* global Routes */

document.addEventListener('turbolinks:load', function () {
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
