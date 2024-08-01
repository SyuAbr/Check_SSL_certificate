class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end
  def destroy
    @tag.destroy
    redirect_to tags_path
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to tags_path
    else
      render :new
    end
  end
  def edit

  end
  def show
    @tag = Tag.find(params[:id])
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_path
    else
      render :edit
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end
  def tag_params
    params.require(:tag).permit(:name, :bot_token)
  end
end
