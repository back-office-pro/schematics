import ApplicationController from './application_controller'
import { SwaggerUIBundle } from 'swagger-ui-dist'
import { schematicsOpenApiEn } from 'routes'

export default class extends ApplicationController {
  connect () {
    SwaggerUIBundle({
      url: schematicsOpenApiEn(),
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
