class GuessController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def show
  end

  def create
    sha = Digest::SHA1.hexdigest(params[:password]).upcase
    response = PasswordCheck.new(sha).check
    render json: {result: response[:message]}, status: response[:status]
  end

  private

  def guess_params
    params.require(:sha).permit(:sha)
  end
end
