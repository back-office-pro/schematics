# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Viewer
    module Schema
      class Component < ApplicationComponent # rubocop:disable Metrics/ClassLength
        option :schema

        def before_render
          add_association_edges
          add_habtm_edges
          add_enum_edges
          add_entity_nodes
          add_enum_nodes
          add_state_machine_clusters
        end

        memoize def output = graph.output(svg: ::String)

        def render?
          schema.present?
        end

        private

        def add_association_edges = entities
          .flat_map(&:association_attributes)
          .each { graph.add_edges(_1.entity.name, _1.inverse_entity.name, arrowhead: 'none') }

        def entities = schema
          .entities
          .reject(&:core?)

        def add_habtm_edges = entities
          .flat_map(&:has_and_belongs_to_many_associations)
          .reject(&:hidden?)
          .each { graph.add_edges(_1.entity.name, _1.association_type, dir: 'both') }

        def add_enum_edges = entities
          .flat_map(&:enum_attributes)
          .grep_v(Attributes::StateMachine)
          .each { graph.add_edges(_1.entity.name, _1.to_sql, label: "  #{_1.name}", arrowhead: 'none', style: 'dashed') } # rubocop:disable Layout/LineLength

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

        def add_entity_nodes = entities
          .each do |entity|
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

        def add_enum_nodes = entities
          .flat_map(&:enum_attributes)
          .grep_v(Attributes::StateMachine)
          .each do |enum|
            graph.add_nodes enum.to_sql, label: <<~HTML
              <<table border='0' cellborder='0' cellspacing='0'>
                <tr>
                  <td>
                    <b>#{enum.enum_type}</b>
                  </td>
                </tr>
                #{enum.values.map(&method(:enum_value_template)).join}
              </table>>
            HTML
          end

        def add_state_machine_clusters = entities
          .flat_map(&:state_machine_attributes)
          .each do |attribute|
            graph.public_send(:"cluster_#{attribute.to_sql}") do |subgraph|
              subgraph[:label] = "<<b>#{attribute.enum_type}</b>>"
              subgraph[:fontname] = 'Helvetica, Arial, sans-serif'
              subgraph[:fontsize] = 10
              subgraph[:color] = 'transparent'
              subgraph.node[:shape] = 'oval'
              subgraph.node[:color] = 'transparent'
              attribute.events.each do |event|
                subgraph.add_edges(event.from, event.to, label: "  #{event.name}", style: 'dashed')
              end
            end
          end

        def attribute_template(attribute)
          case attribute
          when Attributes::Enum
            <<~HTML.squish
              <tr>
                <td align='left'>
                  + #{attribute.name}: <i>#{attribute.enum_type}</i>
                </td>
              </tr>
            HTML
          else
            <<~HTML.squish
              <tr>
                <td align='left'>
                  + #{attribute.name}: <i>#{attribute.type}</i>
                </td>
              </tr>
            HTML
          end
        end

        def virtual_template(virtual)
          <<~HTML.squish
            <tr>
              <td align='left'>
                - #{virtual.name}: <i>#{virtual.type}</i>
              </td>
            </tr>
          HTML
        end

        def enum_value_template(value)
          <<~HTML.squish
            <tr>
              <td align='left'>
                #{value}
              </td>
            </tr>
          HTML
        end
      end
    end
  end
end
