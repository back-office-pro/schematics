# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  class ExceptionController < ApplicationController
    allow_unauthenticated_access
    layout 'schematics/jumbotron'

    def internal_server_error
      respond_to do |format|
        format.html
        format.json { head :internal_server_error }
      end
    end

    def maintenance_mode
      respond_to do |format|
        format.html
        format.json { head :service_unavailable }
      end
    end

    def not_found
      respond_to do |format|
        format.html
        format.json { head :not_found }
      end
    end

    def offline; end
  end
end
