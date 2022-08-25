import ApplicationController from './application_controller'
import { SwaggerUIBundle } from 'swagger-ui-dist'

/* global routes */

export default class extends ApplicationController {
  connect () {
    SwaggerUIBundle({
      url: routes.openApi,
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
