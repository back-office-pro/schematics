import ApplicationController from 'controllers/application_controller'
import { SwaggerUIBundle } from 'swagger-ui-dist'

export default class extends ApplicationController {
  static get values () {
    return { spec: Object }
  }

  connect () {
    SwaggerUIBundle({
      spec: this.specValue,
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
