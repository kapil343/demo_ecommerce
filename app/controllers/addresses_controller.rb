class AddressesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @addresses = @user.addresses
  end
  def new
    # @user = User.find(params[:user_id])
    # @address = @user.addresses.new
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
    @address = @user.addresses.where(id: params[:id])
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
  # def update
    # @address = current_user.addresses.find(params[:id])
    # @address.update(address: params[:address])
    # redirect_back(fallback_location: edit_user_registration_path)

  # end
  # def destroy
    # @address = current_user.addresses.find(params[:id])
    # @address.current_user.update(address: nil) # Remove user's address
    # redirect_back(fallback_location: edit_user_registration_path)
  # end
  private
  def address_params
    params.require(:address).permit(:state, :city, :pincode, :user_id)
  end
end
