module Api
  module V1
    class WebsitesController < ApplicationController
      before_action :authenticate_user_by_token!

      def create
        @website = @current_user.websites.new(website_params)

        if @website.save
          render json: { website: @website }, status: :created
        else
          render json: { errors: @website.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def authenticate_user_by_token!
        token = request.headers['Authorization']
        Rails.logger.info "Received Authorization token: #{token}"
        @current_user = User.find_by(api_token: token)
        if @current_user
          Rails.logger.info "User authenticated: #{@current_user.id}"
        else
          Rails.logger.warn "Unauthorized access attempt with token: #{token}"
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      def website_params
        params.require(:website).permit(:address, :certificate_expiration, :tag_names)
      end
    end
  end
end
