# Copyright © 2025 Dev & Software. All rights reserved.
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
          add_state_machine_clusters
        end

        memoize def output = graph.output(svg: ::String)

        def render?
          schema.present?
        end

        private

        def add_association_edges
          entities.each do |entity|
            entity.association_attributes.each do |association|
              graph.add_edges(association.entity.name, association.inverse_entity.name)
            end
          end
        end

        def entities = schema
          .entities
          .reject(&:core?)

        memoize def graph
          graph = GraphViz.digraph('schema')
          graph[:bgcolor] = 'transparent'
          graph.node[:shape] = 'plaintext'
          graph.node[:fontname] = 'Helvetica, Arial, sans-serif'
          graph.node[:fontsize] = 10
          graph.node[:style] = 'filled'
          graph.node[:fillcolor] = 'gray97'
          graph.edge[:fontname] = 'Helvetica, Arial, sans-serif'
          graph.edge[:fontsize] = 10
          graph
        end

        def add_habtm_edges
          entities.each do |entity|
            entity
              .has_and_belongs_to_many_associations
              .reject(&:hidden?)
              .each do |association|
                graph.add_edges(association.entity.name, association.association_type, dir: 'both')
              end
          end
        end

        def add_entity_nodes
          entities.each do |entity|
            graph.add_nodes entity.name, label: <<~HTML
              <<table border='0' cellborder='0' cellspacing='0'>
                <tr>
                  <td>
                    <b>#{entity.name.humanize}</b>
                  </td>
                </tr>
                #{entity.non_association_attributes.map(&method(:attribute_template)).join}
                #{entity.virtuals.map(&method(:virtual_template)).join}
              </table>>
            HTML
          end
        end

        def add_state_machine_clusters
          entities
            .flat_map(&:state_machine_attributes)
            .each_with_index do |attribute, index|
              graph.public_send(:"cluster_#{index}") do |subgraph|
                subgraph[:label] = "<<b>#{attribute.entity.name.humanize} #{attribute.name} *</b>>"
                subgraph[:fontname] = 'Helvetica, Arial, sans-serif'
                subgraph[:fontsize] = 10
                subgraph[:color] = 'transparent'
                subgraph.node[:shape] = 'oval'
                subgraph.node[:color] = 'transparent'
                attribute.events.each do |event|
                  subgraph.add_edges(event.from, event.to, label: event.name)
                end
              end
            end
        end

        def attribute_template(attribute)
          <<~HTML.squish
            <tr>
              <td align='left'>
                + #{attribute.name} :<i>#{attribute.type}</i>
              </td>
            </tr>
          HTML
        end

        def virtual_template(virtual)
          <<~HTML.squish
            <tr>
              <td align='left'>
                - #{virtual.name} :<i>#{virtual.type}</i>
              </td>
            </tr>
          HTML
        end
      end
    end
  end
end
