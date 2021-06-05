# frozen_string_literal: true

require 'csv'

class CsvImporter
  delegate :model_name, :entity, to: :@model_class, private: true
  attr_reader :errors

  def initialize(file, model_class, current_user)
    @file = file
    @model_class = model_class
    @current_user = current_user
    @errors = {}
  end

  def import
    return :content_type_error unless @file.content_type == 'text/csv'

    data = validate(read_csv_data)
    return :import_error if @errors.any?

    insert_all_paper_trail_versions(@model_class.insert_all(data).pluck('id').flatten) # rubocop:disable Rails/SkipsModelValidations
    @model_class.reindex
    :ok
  end

  private

  def insert_all_paper_trail_versions(record_ids)
    Schematics::Version.insert_all(record_ids.map(&method(:paper_trail_version))) # rubocop:disable Rails/SkipsModelValidations
  end

  def paper_trail_version(id)
    {
      item_type: model_name.to_s,
      item_id: id,
      event: 'import',
      whodunnit: @current_user.id,
      created_at: Time.current,
    }
  end

  def read_csv_data
    data = {}
    CSV.foreach(@file, headers: true).with_index(1) { |row, line| data[line] = row }
    data
      .transform_values(&:to_h)
      .transform_values(&method(:convert_row))
      .to_h
      .transform_values(&:compact)
  end

  def validate(data)
    data.flat_map do |line, attributes|
      resource = @model_class.new(attributes)
      resource.validate!
      resource
        .attributes
        .compact
        .merge(created_at: Time.current, updated_at: Time.current)
    rescue StandardError => e
      @errors[line] = e
    end
  end

  def convert_row(row)
    row.map do |key, value|
      [transform_key(key), transform_value(transform_key(key), value)]
    end.to_h
  end

  def transform_key(key)
    i18n_translations&.invert&.fetch(key, nil) || key.parameterize(separator: '_')
  end

  def transform_value(key, value) # rubocop:disable Metrics/CyclomaticComplexity
    field = entity.find_field_by_name(key.to_s)
    case field
    when Schematics::Attributes::Association
      field
        .class_name
        .constantize
        .joins(field.descriptor.joins)
        .where("#{field.descriptor.to_sql} = ?", value)
        .first!
    when Schematics::Attributes::Enum
      i18n_translations&.dig(field.name.pluralize.to_sym)&.invert&.fetch(value, nil) ||
        value.parameterize(separator: '_')
    when Schematics::Attributes::Country
      field.input_collection.map(&:reverse).to_h.fetch(value)
    when Schematics::Virtuals::Virtual
      nil
    else
      value
    end
  end

  def i18n_translations
    @i18n_translations ||= I18n
                           .t('.')
                           .dig(:activerecord, :attributes, model_name.to_s.underscore.to_sym)
  end
end
