require 'acceptance_helper'

resource "Sessions" do
  shared_setup
  fixtures :users

  let(:user) { users(:two) }
  let(:email) { user.email }
  let(:auth_token) { JsonWebToken.encode(auth_token: user.auth_token) }

  post "/sessions" do
    with_options scope: :user, with_example: true do
      parameter :email, "The user email", required: true
      parameter :password, "The user password", required: true
    end

    context "when credentials are correct" do
      let(:password) { "secret" }

      example "login" do
        do_request
        expect(response_status).to eq(200)
        expect(json_response).to eq({ "auth_token" => auth_token })
      end
    end

    context "when credentials are wrong" do
      let(:password) { "qwerty" }

      example "login" do
        do_request
        expect(response_status).to eq(401)
      end
    end
  end
end
