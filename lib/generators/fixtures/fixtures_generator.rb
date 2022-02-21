# frozen_string_literal: true

class FixturesGenerator < Rails::Generators::NamedBase
  def create_active_storage_fixtures_directory
    return if destroying?

    empty_directory(active_storage_path)
  end

  def create_action_text_fixtures_directory
    return if destroying?

    empty_directory(action_text_path)
  end

  def create_attachments_fixtures_file
    return if destroying?
    return if File.exist?(attachments_file_path)

    create_file(attachments_file_path)
  end

  def create_blobs_fixtures_file
    return if destroying?
    return if File.exist?(blobs_file_path)

    create_file(blobs_file_path)
  end

  def create_rich_texts_fixtures_file
    return if destroying?
    return if File.exist?(rich_texts_file_path)

    create_file(rich_texts_file_path)
  end

  def generate_action_text_rich_texts
    entity
      .rich_text_attributes
      .each
      .with_index(1, &method(:append_to_rich_texts_file))
  end

  def generate_active_storage_attachments
    entity
      .attachment_attributes
      .each
      .with_index(1, &method(:append_to_attachments_file))
  end

  def generate_active_storage_blobs
    entity
      .attachment_attributes
      .each
      .with_index(1, &method(:append_to_blobs_file))
  end

  private

  def entity
    Schematics::Schema
      .instance
      .find_entity_by_name(name.underscore)
  end

  def append_to_blobs_file(attribute, root_index)
    2.times do |index|
      append_to_file(blobs_file_path) do
        <<~YAML
          #{human_root_index(root_index, index)}:
            key: #{generate_blob_key(attribute, root_index, index)}
            filename: dummy.#{attribute.extension}
            content_type: #{Mime[attribute.extension]}
            service_name: test
            byte_size: 6381
            checksum: XqaZqieypVz5akNq/VVJIg==
        YAML
      end
    end
  end

  def append_to_rich_texts_file(attribute, root_index)
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

  def append_to_attachments_file(attribute, root_index)
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

  def human_root_index(root_index, index)
    ((root_index * 2) + index.pred).humanize
  end

  def human_index(index)
    index.next.humanize
  end

  def generate_blob_key(attribute, root_index, index)
    [attribute.entity.name, attribute.name, human_root_index(root_index, index)].join('_')
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
