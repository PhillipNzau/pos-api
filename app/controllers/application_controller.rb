# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
    before_action :authorized
    before_action :authorize_admin_or_charity
    attr_reader :current_user
    ALGORITHM = 'HS256'.freeze
    if Rails.env.development?
      # Development environment: Use the secrets.yml file
      SECRET_KEY = Rails.application.secrets.secret_key_base
    else
      # Production environment: Use the environment variable
      SECRET_KEY = ENV['RAILS_SECRET_KEY']
    end
  
    def encode_token(payload, expiration = 15.minutes.from_now)
      payload[:exp] = expiration.to_i
      JWT.encode(payload, SECRET_KEY, ALGORITHM)
    end
  
    def auth_header
      request.headers['Authorization']
    end
  
    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, SECRET_KEY, true, algorithm:ALGORITHM)
        rescue JWT::DecodeError
          nil
        end
      end
    end
  
    def current_user
      if decoded_token
        user_id = decoded_token[0]['user_id']
        @current_user = User.find_by(id: user_id)
      end
    end
  
    def logged_in?
      !!current_user
    end
  
    def authorized
      puts "SECRET_KEY: #{SECRET_KEY}" 
      render json: { error: "User is Unauthorized #{SECRET_KEY}" }, status: :unauthorized unless logged_in?
    end
  
    def refresh_token(payload)
      token = encode_token(payload)
      refresh_token = JWT.encode(payload.merge({ exp: 1.week.from_now.to_i }), SECRET_KEY)
      { token: token, refresh_token: refresh_token }
    end

    def authorize_admin_or_charity
      return if current_user && (current_user["role"].downcase == "admin" || current_user["role"].downcase == "charity")
  
      render json: { error: 'User not charity or Admin Unauthorized' }, status: :unauthorized
    end
end
  