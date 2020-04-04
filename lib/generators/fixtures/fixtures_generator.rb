class FixturesGenerator < Rails::Generators::Base
  source_root File.expand_path('files', __dir__)

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
      content_type = attribute.validators[:content_type]&.first
      append_to_file "test/fixtures/active_storage/blobs.yml" do
        <<~YAML
        #{index}:
          key: #{SecureRandom.base58}
          filename: #{SecureRandom.base58}.#{content_type || "png"}
          content_type: #{Mime[content_type] || "image/png"}
          byte_size: 2000
          checksum: #{SecureRandom.base58}
        YAML
      end
    end
  end

  def copy_fixture_files
    directory ".", "test/fixtures/files"
  end
end
