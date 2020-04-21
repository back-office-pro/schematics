class FixturesGenerator < Rails::Generators::Base
  def generate_action_text_rich_texts
    Schematics::SCHEMA.entities.map(&:rich_text_attributes).flatten.each.
      with_index(1) do |attribute, root_index|
      2.times do |index|
        append_file(rich_texts_file_path) do
          <<~YAML
          #{human_root_index(root_index, index)}:
            record: #{human_index(index)} (#{attribute.entity.class_name})
            name: #{attribute.name}
            body: <p>In a <i>million</i> stars!</p>
          YAML
        end
      end
    end
  end

  def create_active_storage_fixtures_directory
    empty_directory(active_storage_path)
  end

  def generate_active_storage_attachments
    create_file(attachments_file_path)
    Schematics::SCHEMA.entities.map(&:attachment_attributes).flatten.each.
      with_index(1) do |attribute, root_index|
      2.times do |index|
        append_to_file(attachments_file_path) do
          <<~YAML
          #{human_root_index(root_index, index)}:
            record: #{human_index(index)} (#{attribute.entity.class_name})
            name: #{attribute.name}
            blob: #{human_root_index(root_index, index)}
          YAML
        end
      end
    end
  end

  def generate_active_storage_blobs
    create_file(blobs_file_path)
    Schematics::SCHEMA.entities.map(&:attachment_attributes).flatten.each.
      with_index(1) do |attribute, root_index|
      2.times do |index|
        append_to_file(blobs_file_path) do
          <<~YAML
          #{human_root_index(root_index, index)}:
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

  private

  def human_root_index(root_index, index)
    (root_index * 2 + (index - 1)).humanize
  end

  def human_index(index)
    (index + 1).humanize
  end

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
