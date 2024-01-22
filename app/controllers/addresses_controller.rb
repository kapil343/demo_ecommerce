class AddressesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @addresses = @user.addresses
  end
  def new
    @address = current_user.addresses.build
  end
  def create
    @user = User.find(params[:user_id])
    @address = @user.addresses.new(address_params)
    if @address.save
      redirect_to user_addresses_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    @user = User.find(params[:user_id])
    @address = @user.addresses.find_by(id: params[:id])
  end
  def update
    @user = User.find(params[:user_id])
    if @user.addresses.update(address_params)
      redirect_to user_addresses_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @user = User.find(params[:user_id])
    @address = @user.addresses.find(params[:id])
    @address.destroy
    redirect_back(fallback_location: edit_user_registration_path)
  end

  private
  def address_params
    params.require(:address).permit(:state, :city, :pincode, :user_id)
  end
end
