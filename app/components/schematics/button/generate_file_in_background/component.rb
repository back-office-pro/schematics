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
  module Button
    module GenerateFileInBackground
      class Component < ApplicationComponent
        option :extension
        option :text
        option :url, optional: true
        option :dropdown, default: -> { false }

        class << self
          def csv_template(**)
            new(extension: :csv, text: :download_csv_template, **)
          end

          def csv(**)
            new(extension: :csv, text: :download_as_csv, **)
          end

          def pdf(**)
            new(extension: :pdf, text: :download_pdf, **)
          end
        end

        def title = t(".#{text}")

        def action
          'click->generate-file-in-background#run' unless dropdown?
        end

        def dropdown? = dropdown

        def icon = :"file_#{extension}"

        def toggle
          'dropdown' if dropdown?
        end

        def browser_missing?
          return false unless extension == :pdf

          !Ferrum::Browser::Command.build(Ferrum::Browser::Options.new, nil)
        rescue Ferrum::BinaryNotFoundError
          true
        end
      end
    end
  end
end
