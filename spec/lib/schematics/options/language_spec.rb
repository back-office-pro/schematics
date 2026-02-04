# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Options::Language do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:language) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:openai_description) { is_expected.to eq('The language of the code editor') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:to_openai_schema) do
    is_expected.to eq(
      language: {
        type: 'object',
        additionalProperties: false,
        required: %w[language],
        properties: {
          language: {
            type: 'string',
            description: 'The language of the code editor',
            enum: %w[
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
          }
        }
      }
    )
  end

  its(:collection) do
    is_expected.to eq(
      %w[
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
    )
  end
end
