class AddressesController < ApplicationController
  before_action :set_address, only: [:edit, :destroy]
  before_action :load_user_addresses, only: [:index, :new, :create, :update]

  def index
    @addresses = @addresses
  end

  def new
    @address = @addresses.build
  end

  def create
    address = @addresses.new(address_params)
    if address.save
      redirect_to user_addresses_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @address
  end

  def update
    if @addresses.update(address_params)
      redirect_to user_addresses_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_back(fallback_location: edit_user_registration_path)
  end

  private

    def address_params
      params.require(:address).permit(:state, :city, :pincode, :user_id)
    end

    def set_address
      @address = current_user.addresses.find_by(id: params[:id])
    end

    def load_user_addresses
      @addresses = current_user.addresses
    end
end
