class Api::V1::ConstituenciesController < ApplicationController
  def index
    constits = if index_params.present?
                 Constituency.where(index_params)
               else
                 Constituency.all
               end

    return render json: { "error": 'Unable to find constituencies' }, status: 404 if constits.nil?

    constit_json = ConstituencySerializer.new(constits).serializable_hash.to_json
    render json: constit_json
  end

  def show
    constit = Constituency.find_by(id: show_params[:id])
    return render json: { "error": 'Unable to find members' }, status: 404 if constit.nil?

    constit_json = ConstituencySerializer.new(constit).serializable_hash.to_json
    render json: constit_json
  end

  private

  def index_params
    params.permit(:id, :name, :district_number, :current_caucus, :region)
  end

  def show_params
    params.permit(:id)
  end
end
