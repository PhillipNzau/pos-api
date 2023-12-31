class AuthenticationService
    SECRET_KEY = Rails.application.secrets.secret_key_base
    ALGORITHM = 'HS256'.freeze
  
    def self.encode(payload, expiration = 15.minutes.from_now)
      payload[:exp] = expiration.to_i
      JWT.encode(payload, SECRET_KEY, ALGORITHM)
    end
  
    def self.decode(token)
      JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM)[0]
    rescue JWT::DecodeError
      nil
    end
end