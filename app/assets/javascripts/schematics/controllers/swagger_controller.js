import ApplicationController from 'controllers/application_controller'
import { SwaggerUIBundle } from 'swagger-ui-dist'

/* global routes */

export default class extends ApplicationController {
  connect () {
    SwaggerUIBundle({
      url: `${window.location.pathname}.json`,
      domNode: this.element,
      docExpansion: 'none',
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
      ],
      plugins: [
        SwaggerUIBundle.plugins.DownloadUrl
      ]
    })
  }
}
