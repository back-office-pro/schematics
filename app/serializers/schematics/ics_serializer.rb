# frozen_string_literal: true

module Schematics
  class IcsSerializer
    delegate :class, to: :@resource, prefix: :model, private: true
    delegate :human_name, :entity, to: :model_class, private: true
    delegate :start_date_attribute_name,
             :end_date_attribute_name,
             :string_attributes,
             :url_attributes,
             :address_attributes,
             :rich_text_attributes,
             to: :entity,
             private: true

    def initialize(resource)
      @resource = resource
    end

    def content_type = ::Mime[extension].to_s

    def extension = :ics

    def content = calendar.to_ical

    def filename = "#{human_name.dasherize}-#{@resource.slug}.#{extension}"

    private

    def calendar
      @calendar ||= begin
        calendar = Icalendar::Calendar.new
        calendar.event do |event|
          event.dtstart = dtstart
          event.dtend = dtend
          event.summary = summary
          event.description = description
          event.url = url
          event.location = location
        end
        calendar
      end
    end

    def dtstart
      Icalendar::Values::DateTime.new @resource.public_send(start_date_attribute_name)
    end

    def dtend
      Icalendar::Values::DateTime.new @resource.public_send(end_date_attribute_name)
    end

    def summary
      return if string_attributes.none?

      @resource.public_send(string_attributes.first.name)
    end

    def url
      return if url_attributes.none?

      @resource.public_send(url_attributes.first.name)
    end

    def location
      return if address_attributes.none?

      @resource.public_send(address_attributes.first.name)
    end

    def description
      return if rich_text_attributes.none?

      @resource
        .public_send(rich_text_attributes.first.name)
        .to_plain_text
    end
  end
end
