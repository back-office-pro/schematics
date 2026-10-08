# frozen_string_literal: true

module Schematics
  module Options
    class Language < Option
      class << self
        def input_type = :select

        def controller = 'dropdown'

        def multiple? = false

        def collection = %w[
          abap
          aes
          apex
          azcli
          bat
          bicep
          c
          cameligo
          clojure
          coffeescript
          cpp
          csharp
          csp
          css
          cypher
          dart
          dockerfile
          ecl
          elixir
          flow9
          freemarker2
          freemarker2.tag-angle.interpolation-bracket
          freemarker2.tag-angle.interpolation-dollar
          freemarker2.tag-auto.interpolation-bracket
          freemarker2.tag-auto.interpolation-dollar
          freemarker2.tag-bracket.interpolation-bracket
          freemarker2.tag-bracket.interpolation-dollar
          fsharp
          go
          graphql
          handlebars
          hcl
          html
          ini
          java
          javascript
          json
          julia
          kotlin
          less
          lexon
          liquid
          lua
          m3
          markdown
          mdx
          mips
          msdax
          mysql
          objective-c
          pascal
          pascaligo
          perl
          pgsql
          php
          pla
          plaintext
          postiats
          powerquery
          powershell
          proto
          pug
          python
          qsharp
          r
          razor
          redis
          redshift
          restructuredtext
          ruby
          rust
          sb
          scala
          scheme
          scss
          shell
          sol
          sparql
          sql
          st
          swift
          systemverilog
          tcl
          twig
          typescript
          vb
          verilog
          wgsl
          xml
          yaml
        ]

        def openai_type = 'string'

        def openai_description = 'The language of the code editor'

        def openai_enum = { enum: collection }
      end
    end
  end
end
