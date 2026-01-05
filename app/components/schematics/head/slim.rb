# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Head::SLIM = <<~SLIM
  head
    meta charset='utf-8'
    meta name='viewport' content='width=device-width,initial-scale=1'
    meta name='apple-mobile-web-app-capable' content='yes'
    meta name='mobile-web-app-capable' content='yes'
    meta name='application-name' content=company_name
    meta name='theme-color' content=theme_color
    meta name='turbo-view-transition' content='same-origin'
    meta name='turbo-prefetch' content='true'
    = turbo_refreshes_with method: :replace, scroll: :reset
    = turbo_exempts_page_from_cache_tag
    = content_for :head
    title \#{company_name} - \#{title}
    = csrf_meta_tags
    = csp_meta_tag
    = __favicon
    = stylesheet_link_tag :app, 'data-turbo-track': 'reload'
    = javascript_importmap_tags
    = javascript_include_tag 'pagy'
    = javascript_include_tag 'https://www.gstatic.com/charts/loader.js'
    = __google_map_include_tag
    = __theme_custom_stylesheet
    = __rouge_theme_stylesheet
    = __inline_javascript
    = tag.link rel: 'manifest', href: pwa_manifest_path(format: :json), crossorigin: 'use-credentials'
SLIM
