require 'acceptance_helper'

resource "Password Resets" do
  shared_setup
  fixtures :users
  fixtures :roles

  let(:user) { users(:two) }

  post "/password_resets" do
    with_options scope: :user, with_example: true do
      parameter :email, "The user email", required: true
    end

    context "when email exists" do
      let(:email) { user.email }

      example "ask for new password" do
        do_request
        expect(response_status).to eq(204)
      end
    end

    context "when email does not exist" do
      let(:email) { "foo@foo.com" }

      example "ask for new password" do
        do_request
        expect(response_status).to eq(422)
      end
    end
  end

  put "/password_resets/:token" do
    with_options with_example: true do
      parameter :token, "The password reset token", required: true
    end

    with_options scope: :user, with_example: true do
      parameter :password, "The new user password", required: true
      parameter :password_confirmation, "The new user password confirmation", required: true
    end

    context "when token exists" do
      let(:token) { user.password_reset_token }

      context "when password is equal to password_confirmation" do
        let(:password) { "azerty" }
        let(:password_confirmation) { "azerty" }

        example "password reset" do
          do_request
          expect(response_status).to eq(204)
        end
      end

      context "when password is not equal to password_confirmation" do
        let(:password) { "azerty" }
        let(:password_confirmation) { "qwerty" }

        example "password reset" do
          do_request
          expect(response_status).to eq(422)
        end
      end
    end

    context "when token does not exist" do
      let(:token) { "foo" }

      example "password reset" do
        do_request
        expect(response_status).to eq(404)
      end
    end
  end
end
