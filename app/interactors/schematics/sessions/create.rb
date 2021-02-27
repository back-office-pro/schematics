module Schematics
  module Sessions
    class Create
      include Interactor

      before do
        @params   = context.user_params
        @password = context.password || @params[:password]
        @cookies  = context.cookies
        @user     = context.resource || User.find_by(email: @params[:email])
      end

      def call
        if @user&.authenticate(@password)
          context.token = @user.auth_token
          context.jwt = JsonWebToken.encode({ auth_token: context.token })
          context.message = '.success'
          if @cookies.present?
            if remember_me?
              @cookies.permanent[:auth_token] = context.token
            else
              @cookies[:auth_token] = context.token
            end
          end
        else
          context.fail!(message: '.failure')
        end
      end

      private

      def remember_me?
        context.remember_me
      end
    end
  end
end
