User.create!(email: "admin@admin.com", password: "123456", first_name: "Jean", last_name: "Dupont")
Setting.instance.update(company_name: Rails.application.class.module_parent_name, theme: "flatly")
