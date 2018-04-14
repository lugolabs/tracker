# frozen_string_literal: true

class UsersController < Clearance::UsersController
  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = user_from_params
    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render :new
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_user_path, notice: '<i class="iconly-0651-smile mr-2"></i> Great! All updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :time_zone)
  end
end
