/*
 * Copyright © 2025 Dev & Software. All rights reserved.
 *
 * THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
 * REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
 * NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
 * LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.
 */

import ApplicationController from 'controllers/application_controller'
import { Popover } from 'bootstrap'

export default class extends ApplicationController {
  connect () {
    this.#setTableAllowList()
    new Popover(this.element) // eslint-disable-line no-new
  }

  #setTableAllowList () {
    Popover.Default.allowList.table = []
    Popover.Default.allowList.thead = []
    Popover.Default.allowList.tbody = []
    Popover.Default.allowList.tr = []
    Popover.Default.allowList.th = []
    Popover.Default.allowList.td = []
  }
}
