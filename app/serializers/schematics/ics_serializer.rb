# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  class ICSSerializer
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

    memoize def content = calendar&.to_ical

    def filename = "#{human_name.parameterize}-#{@resource.to_param}.#{extension}"

    private

    memoize def calendar
      calendar = Icalendar::Calendar.new
      calendar.event do |event|
        event.dtstart = dtstart
        event.dtend = dtend
        event.summary = summary
        event.description = description
        event.url = url
        event.location = location
      end
      calendar if dtstart && dtend
    end

    def dtstart
      return unless start_date_attribute_name

      Icalendar::Values::DateTime.new @resource.public_send(start_date_attribute_name)
    end

    def dtend
      return unless end_date_attribute_name

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
