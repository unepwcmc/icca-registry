class Api::IccaSitesController < ApplicationController
  def index
    render json: IccaSite.all
  end
end
