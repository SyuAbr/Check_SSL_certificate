class BotController < ApplicationController

  def message()
  end

  def start!(*)
  end

  private

  def with_locale(&action)
    I18n.with_locale(:ru, &action)
  end
end