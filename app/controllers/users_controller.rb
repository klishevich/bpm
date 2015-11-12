class UsersController < ApplicationController

  def index
    @users = User.all.order('name')
    # authorize User
  end

  # def show
  #   @user = User.find(params[:id])
  # end

  def edit
    @user=User.find(params[:id])
    authorize @user
  end
  
  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(user_params)
      flash[:success] = t(:updated_successfuly)
      redirect_to users_path
    else
      render 'edit'
    end
  end
    
  # def destroy
  #   user = User.find(params[:id])
  #   unless user == current_user
  #     user.destroy
  #     redirect_to users_path, :notice => "User deleted."
  #   else
  #     redirect_to users_path, :notice => "Can't delete yourself."
  #   end
  # end

  private

  def user_params
    params.require(:user).permit(:name, :code, :unit_id, :deleted, :admin, 
      users_roles_attributes: [:role_id, :user_id])
  end 

end