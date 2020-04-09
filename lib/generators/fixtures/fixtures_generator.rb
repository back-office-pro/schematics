class FixturesGenerator < Rails::Generators::Base
  def generate_action_text_rich_texts
    Schematics::SCHEMA.entities.map(&:attributes).flatten.
      select_is_a?(Schematics::Attributes::RichText).
      each_with_index do |attribute, index|
      index = (index + 1).humanize
      append_file "test/fixtures/action_text/rich_texts.yml" do
        <<~YAML
        #{index}:
          record: one (#{attribute.entity.type.camelize})
          name: #{attribute.name}
          body: <p>In a <i>million</i> stars!</p>
        YAML
      end
    end
  end

  def generate_active_storage_attachments
    empty_directory "test/fixtures/active_storage"
    create_file "test/fixtures/active_storage/attachments.yml"
    Schematics::SCHEMA.entities.map(&:attributes).flatten.
      select_is_a?(Schematics::Attributes::Attachment).
      each_with_index do |attribute, index|
      index = (index + 1).humanize
      append_to_file "test/fixtures/active_storage/attachments.yml" do
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
    empty_directory "test/fixtures/active_storage"
    create_file "test/fixtures/active_storage/blobs.yml"
    Schematics::SCHEMA.entities.map(&:attributes).flatten.
      select_is_a?(Schematics::Attributes::Attachment).
      each_with_index do |attribute, index|
      index = (index + 1).humanize
      append_to_file "test/fixtures/active_storage/blobs.yml" do
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
end
