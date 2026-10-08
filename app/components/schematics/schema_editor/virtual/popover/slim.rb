# frozen_string_literal: true

Schematics::SchemaEditor::Virtual::Popover::SLIM = <<~SLIM
  table.table.mb-0.table-striped.table-borderless
    tbody
      tr
        th = t('.function')
        td = 'NOW()'
      tr
        th = t('.aggregate_function')
        td = 'SUM($foo.bar) COUNT($foo.bar) AVG($foo.bar) MIN($foo.bar) MAX($foo.bar)'
      tr
        th = t('.arithmetic_function')
        td = 'ABS($foo) ROUND($foo) CEIL($foo) FLOOR($foo) SQRT($foo)'
      tr
        th = t('.combinator')
        td = '&& ||'
      tr
        th = t('.operator')
        td = '* + - / % | & << >>'
      tr
        th = t('.comparator')
        td = '<= >= < > != == NULL'
      tr
        th = t('.variable')
        td = '$foo.bar'
      = row
SLIM
