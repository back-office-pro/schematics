module AcceptanceHelpers
  def shared_setup
    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'

    let(:raw_post) { params.to_json }
    let(:json_response) { JSON.parse(response_body) }
  end

  def token_auth
    header 'Authorization', :auth_token

    fixtures :users

    let(:user) { users(:two) }
    let(:auth_token) { JsonWebToken.encode(auth_token: user.auth_token) }
  end
end
