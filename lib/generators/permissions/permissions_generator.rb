# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class PermissionsGenerator < Rails::Generators::NamedBase
  class_option :rename, type: :string

  def destroy_permissions
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Permission.delete_by(model: name)
      Schematics::Version.where(item_type: name).in_batches.destroy_all
      model_classes.each { _1.where(model: name).in_batches.destroy_all }
    end
  end

  def rename_permissions
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Schematics::Version.where(item_type: old_model).in_batches.update_all(item_type: name) # rubocop:disable Rails/SkipsModelValidations
      model_classes.each { _1.where(model: old_model).in_batches.update_all(model: name) } # rubocop:disable Rails/SkipsModelValidations
    end
  end

  private

  def destroying?
    behavior == :revoke
  end

  def model_classes = Schematics::Schema
    .new
    .entities
    .select { _1.model_attributes.any? }
    .filter_map(&:model_class)

  def renaming?
    behavior == :invoke && old_model
  end

  def old_model = options[:rename]
end
