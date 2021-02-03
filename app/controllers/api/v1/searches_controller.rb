class Api::V1::Searches < ApplicationController
  def member; end

  def constituency; end

  private

  def member_params
    params.permit(:address, :ip_address)
  end

  def constituency_params
    params.permit(:address, :ip_address)
  end
end
