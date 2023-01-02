# frozen_string_literal: true

module Schematics
  module Viewer
    module Schema
      class Component < ApplicationComponent
        option :schema

        def before_render
          add_association_edges
          add_habtm_edges
          add_entity_nodes
        end

        def output
          @output ||= graph.output(svg: ::String)
        end

        def render?
          schema.present?
        end

        private

        def entities = schema
          .entities
          .reject(&:core?)

        def graph
          @graph ||= GraphViz.digraph('schema') do |graph|
            graph[:bgcolor] = 'transparent'
            graph.node[:shape] = 'plaintext'
            graph.node[:fontname] = 'Helvetica, Arial, sans-serif'
            graph.node[:fontsize] = 10
            graph.node[:style] = 'filled'
            graph.node[:fillcolor] = 'gray98'
            graph.edge[:style] = 'dashed'
            graph.edge[:color] = 'gray70'
          end
        end

        def add_association_edges
          entities.each do |entity|
            entity.association_attributes.each do |association|
              graph.add_edges(association.entity.name, association.inverse_entity.name)
            end
          end
        end

        def add_habtm_edges
          entities.each do |entity|
            entity
              .has_and_belongs_to_many_associations
              .reject(&:hidden?)
              .each do |association|
                graph.add_edges(association.entity.name, association.name.singularize, dir: 'both')
              end
          end
        end

        def add_entity_nodes
          entities.each do |entity|
            graph.add_nodes entity.name, label: <<~HTML
              <<table border='0' cellborder='0' cellspacing='0'>
                <tr>
                  <td>
                    <b>#{entity.name}</b>
                  </td>
                </tr>
                #{entity.non_association_attributes.map { "<tr><td align='left'>+ #{_1.name}</td></tr>" }.join}
                #{entity.virtuals.map { "<tr><td align='left'>- #{_1.name}</td></tr>" }.join}
              </table>>
            HTML
          end
        end
      end
    end
  end
end
