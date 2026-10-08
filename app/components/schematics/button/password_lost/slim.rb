# frozen_string_literal: true

Schematics::Button::PasswordLost::SLIM = <<~SLIM
  span data-controller='tooltip' title=title
    = link_to t('.text'), new_password_reset_path, class: css_classes
SLIM
