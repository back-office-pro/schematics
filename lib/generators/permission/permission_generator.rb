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

# :reek:MissingSafeMethod
class PermissionGenerator < Rails::Generators::NamedBase
  class_option :action, type: :string
  class_option :rename, type: :string

  def generate_permission
    return unless generating?

    PaperTrail.request(enabled: false) do
      Role.admin.permissions.push(Permission.create!(model: name, action:))
    end
  end

  def destroy_permission
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Permission.delete_by(model: name, action:)
    end
  end

  def rename_permission
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Permission.where(model: name, action: old_action).update!(action:)
    end
  end

  private

  def generating?
    behavior == :invoke && !old_action
  end

  def old_action = options[:rename]

  def action = options[:action]

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_action
  end
end
