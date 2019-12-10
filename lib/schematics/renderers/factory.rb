module Schematics
  module Renderers
    class Factory
      def self.create(renderable, json: nil, csv: nil, pdf: nil, formatter: nil)
        renderers = {}
        renderers[:json] = Renderers::JSON::Default.new(renderable, json[:order], json[:visible], formatter) unless json.nil?
        renderers[:csv]  = Renderers::CSV::Default.new(renderable, csv[:order], csv[:visible], formatter)    unless csv.nil?
        renderers
      end

      def self.create_custom(renderable, json: nil, csv: nil, pdf: nil, formatter: nil)
        renderers = {}
        renderers[:json] = self.custom_renderer(:json, renderable.type).new(renderable, json[:order], json[:visible], formatter) unless json.nil?
        renderers[:csv]  = self.custom_renderer(:csv, renderable.type).new(renderable, csv[:order], csv[:visible], formatter)    unless csv.nil?
        renderers
      end

      private

      def self.custom_renderer(renderer, type)
        begin
          "Schematics::Renderers::#{renderer.to_s.upcase}::#{type.camelize}".constantize
        rescue
          "Schematics::Renderers::#{renderer.to_s.upcase}::Default".constantize
        end
      end
    end
  end
end
