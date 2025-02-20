# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class PermissionsGenerator < Rails::Generators::NamedBase
  class_option :rename, type: :string

  def destroy_permissions
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Permission.delete_by(model: name)
      Schematics::Version.where(item_type: name).in_batches.destroy_all
      model_classes.each { it.where(model: name).in_batches.destroy_all }
    end
  end

  def rename_permissions
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Schematics::Version.where(item_type: old_model).in_batches.update_all(item_type: name) # rubocop:disable Rails/SkipsModelValidations
      model_classes.each { it.where(model: old_model).in_batches.update_all(model: name) } # rubocop:disable Rails/SkipsModelValidations
    end
  end

  private

  def destroying?
    behavior == :revoke
  end

  def model_classes = Schematics::Schema
    .new
    .entities
    .select { it.model_attributes.any? }
    .filter_map(&:model_class)

  def renaming?
    behavior == :invoke && old_model
  end

  def old_model = options[:rename]
end
