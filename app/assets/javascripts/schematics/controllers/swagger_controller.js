import ApplicationController from './application_controller'
import { SwaggerUIBundle } from 'swagger-ui-dist'

/* global Routes */

export default class extends ApplicationController {
  connect () {
    SwaggerUIBundle({
      url: Routes.schematicsOpenApi(),
      domNode: this.element,
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
