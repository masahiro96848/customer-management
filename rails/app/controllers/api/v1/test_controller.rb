class Api::V1::TestController < ApplicationController
  def index
    render json: { message: "Success Test Check!" }, status: :ok
  end
end
