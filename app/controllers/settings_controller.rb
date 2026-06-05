class SettingsController < ApplicationController
  before_action :authenticate_user!
  
  def edit
    @page_title = "Settings"
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to authenticated_root_path, notice: "Settings updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:billing_start_day)
  end
end
