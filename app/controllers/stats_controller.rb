class StatsController < ApplicationController
  TOTAL_PASSWORDS = 320335236

  # Major WIP
  def index
    total_found = Guess.where(found: true).count
    percentage = TOTAL_PASSWORDS / total_found
    render json: {result: "#{total_found} of #{TOTAL_PASSWORDS} passwords found"}, status: :ok
  end
end
