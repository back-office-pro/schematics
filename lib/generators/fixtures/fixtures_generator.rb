# frozen_string_literal: true

class FixturesGenerator < Rails::Generators::NamedBase
  def create_active_storage_directory
    return if destroying?

    empty_directory(active_storage_path)
  end

  def create_action_text_directory
    return if destroying?

    empty_directory(action_text_path)
  end

  def create_attachments_file
    return if destroying?
    return if File.exist?(attachments_file_path)

    create_file(attachments_file_path)
  end

  def create_blobs_file
    return if destroying?
    return if File.exist?(blobs_file_path)

    create_file(blobs_file_path)
  end

  def create_rich_texts_file
    return if destroying?
    return if File.exist?(rich_texts_file_path)

    create_file(rich_texts_file_path)
  end

  def generate_action_text_rich_texts
    entity
      .rich_text_attributes
      .map(&method(:append_to_rich_texts_file))
  end

  def generate_active_storage_attachments
    entity
      .attachment_attributes
      .map(&method(:append_to_attachments_file))
  end

  def generate_active_storage_blobs
    entity
      .attachment_attributes
      .map(&method(:append_to_blobs_file))
  end

  private

  def entity
    Schematics::Schema
      .instance
      .find_entity_by_name(name.underscore)
  end

  def append_to_blobs_file(attribute)
    (1..2).each do |index|
      append_to_file(blobs_file_path) do
        <<~YAML
          #{root_index(blobs_file_path, index).humanize}:
            key: #{entity.name}_#{attribute.name}_#{index.humanize}
            filename: dummy.#{attribute.extension}
            content_type: #{Mime[attribute.extension]}
            service_name: test
            byte_size: 6381
            checksum: XqaZqieypVz5akNq/VVJIg==
        YAML
      end
    end
  end

  def append_to_rich_texts_file(attribute)
    (1..2).each do |index|
      append_file(rich_texts_file_path) do
        <<~YAML
          #{root_index(rich_texts_file_path, index).humanize}:
            record: #{index.humanize} (#{entity.class_name})
            name: #{attribute.name}
            body: <p>In a <i>million</i> stars!</p>
        YAML
      end
    end
  end

  def append_to_attachments_file(attribute)
    (1..2).each do |index|
      append_to_file(attachments_file_path) do
        <<~YAML
          #{root_index(attachments_file_path, index).humanize}:
            record: #{index.humanize} (#{entity.class_name})
            name: #{attribute.name}
            blob: #{root_index(attachments_file_path, index).humanize}
        YAML
      end
    end
  end

  def root_index(file_path, index)
    fixtures = YAML.load_file(file_path)
    return index unless fixtures

    fixtures.keys.count.next
  end

  def destroying?
    behavior == :revoke
  end

  def fixtures_path
    File.join('test', 'fixtures')
  end

  def active_storage_path
    File.join(fixtures_path, 'active_storage')
  end

  def action_text_path
    File.join(fixtures_path, 'action_text')
  end

  def rich_texts_file_path
    File.join(action_text_path, 'rich_texts.yml')
  end

  def blobs_file_path
    File.join(active_storage_path, 'blobs.yml')
  end

  def attachments_file_path
    File.join(active_storage_path, 'attachments.yml')
  end
end
