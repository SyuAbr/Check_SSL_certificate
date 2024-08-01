# app/controllers/websites_controller.rb
class WebsitesController < ApplicationController
  before_action :set_website, only: [:show, :edit, :update, :destroy]

  def index
    @websites = Website.all
  end

  def show

  end

  def new
    @website = Website.new
  end

  def create
    @website = Website.new(website_params)
    @website.user_id = current_user.id

    if @website.save
      redirect_to websites_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @website.update(website_params)
      redirect_to website_path(@website)
    else
      render :edit
    end
  end

  def destroy
    @website.destroy
    redirect_to websites_path
  end

  private

  def set_website
    @website = Website.find(params[:id])
  end

  def website_params
    params.require(:website).permit(:address,  tag_ids: [])
  end
end
