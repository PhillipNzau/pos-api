class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]
  before_action :authorized, except: %i[register login update]
  before_action :authorize_admin, only: %i[destroy index]

  def register
    user = User.create(user_params)
    if user.save
      render_user_response(user)
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      render_user_response(user)
    else
      render_unauthorized_error
    end
  end

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def update
    user_id = decoded_token[0]['user_id']
    @user = User.find(user_id)
 
    if current_user.update(user_params)
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: {success: "Deleted user successfully"}
  end

  private

  def user_params
    permitted_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :role)
    permitted_params[:role] ||= 'user' # Add default role if not provided
    permitted_params
  end

  def render_user_response(user)
    access_token = encode_token(user_id: user.id)
    refresh_token = encode_token({ user_id: user.id, refresh: true }, 1.week.from_now)
    user_data = {
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      role: user.role
    }
    render json: { user: user_data, access_token: access_token, refresh_token: refresh_token }, status: :created
  end

  def render_unauthorized_error
    render json: { error: "Invalid username or password" }, status: :unauthorized
  end

  def set_user
    @user = User.find(params[:id])
  end
end
