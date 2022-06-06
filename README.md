![GitHub CI](https://github.com/maksjs/schematics/actions/workflows/build.yml/badge.svg)

# Schematics

Dependencies choices details.

### Searching, Sorting, filterting

:star: **searchkick**

:+1: Most recent and popular solution

:+1: Most performant

:+1: Suggestions

:+1: Scalable

:+1: Easier eager loading, no need for joins

:+1: Enable search in *Text* and *RichText* without newlines and HTML tags

:-1: We need the elasticsearch / opensearch daemon

~~ransack~~

:+1: More robust than has_scope

:+1: More search patterns (_cont, _matches, _any...)

:-1: We need to monkey patch sorting by alias

:-1: Not so much maintained

~~has_scope~~

~~pg_search~~

:-1: Only works with text fields (no range fields for ex)

### Testing

:star: **rspec**

:+1: Rspec is the most popular testing framework

~~minitest + fixtures ~~

:-1: Fixtures files are hardcoded

### API Documentation

:star: **zero-rails_openapi**

:+1: Open API documentation

### Pagination

:star: **pagy**

:+1: Most performant

:+1: Most recent

~~kaminari~~

~~will_paginate~~

### API JSON

:star: **active_model_serializers**

~~from scratch~~

:-1: Works badly with `ActionText` and `Attachment`

:-1: We need `olive_banch` to camelize keys

~~fast_jsonapi~~

:+1: Most performant

:-1: Only compatible with JSONAPI

### Soft deletes

:star: **paranoia**

:+1: Most simple

:-1: Does not work with Rails 6.1 *destroy_async*

~~act_as_paranoid~~

:-1: Older gem

~~discard~~

:+1: Most recent gem

:-1: No support for recursive deletes

### Model tracking & versioning

:star: **paper_trail**

:+1: Most popular

~~audited~~

:-1: No metada to bind `ActionText` and `ActiveStorage`

~~public_activity~~

:-1: Shipped with default views

~~logidze~~

:+1: Most performant (database level tracking)

:-1: Not possible to have a global timeline

### PDF generation

:star: **grover**

:+1: View system

:+1: Use puppeteer internally with cutting-edge features

~~wkhtmltopdf~~

:+1: View system

:-1: No support for CSS variables and Bootstrap 5 (the driver is too old)

~~prawn~~

:-1: No view system

~~PDFKit~~

### Auth

:star: **from scratch**

:+1: Most personalizable solution

:+1: We can use `User` from core system

~~devise + devise_auth_token~~

:-1: Not enough personalizable

~~cleareance~~

~~sorcery~~

~~knock~~

### Roles & Permissions

:star: **cancancan**

:+1: Most simple

~~Pundit~~

:-1: No view helpers
