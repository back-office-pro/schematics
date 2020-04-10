class FixturesGenerator < Rails::Generators::Base
  def generate_action_text_rich_texts
    Schematics::SCHEMA.entities.map(&:attributes).flatten.
      select_is_a?(Schematics::Attributes::RichText).
      each_with_index do |attribute, index|
      index = (index + 1).humanize
      append_file(rich_texts_file_path) do
        <<~YAML
        #{index}:
          record: one (#{attribute.entity.type.camelize})
          name: #{attribute.name}
          body: <p>In a <i>million</i> stars!</p>
        YAML
      end
    end
  end

  def create_active_storage_fixtures_directory
    empty_directory(active_storage_path)
  end

  def generate_active_storage_attachments
    create_file(attachments_file_path)
    Schematics::SCHEMA.entities.map(&:attributes).flatten.
      select_is_a?(Schematics::Attributes::Attachment).
      each_with_index do |attribute, index|
      index = (index + 1).humanize
      append_to_file(attachments_file_path) do
        <<~YAML
        #{index}:
          record: one (#{attribute.entity.type.camelize})
          name: #{attribute.name}
          blob: #{index}
        YAML
      end
    end
  end

  def generate_active_storage_blobs
    create_file(blobs_file_path)
    Schematics::SCHEMA.entities.map(&:attributes).flatten.
      select_is_a?(Schematics::Attributes::Attachment).
      each_with_index do |attribute, index|
      index = (index + 1).humanize
      append_to_file(blobs_file_path) do
        <<~YAML
        #{index}:
          key: #{ActiveStorage::Blob.generate_unique_secure_token}
          filename: dummy.#{attribute.extension}
          content_type: #{Mime[attribute.extension]}
          byte_size: 6381
          checksum: XqaZqieypVz5akNq/VVJIg==
        YAML
      end
    end
  end

  private

  def fixtures_path
    File.join("test", "fixtures")
  end

  def active_storage_path
    File.join(fixtures_path, "active_storage")
  end

  def rich_texts_file_path
    File.join(fixtures_path, "action_text", "rich_texts.yml")
  end

  def blobs_file_path
    File.join(active_storage_path, "blobs.yml")
  end

  def attachments_file_path
    File.join(active_storage_path, "attachments.yml")
  end
end
