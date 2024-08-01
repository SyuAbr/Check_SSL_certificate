Rails.application.config.to_prepare do
  Telegram.bots_config = Tag.all.each_with_object({}) do |tag, config|
    config[tag.name.to_sym] = { token: tag.bot_token }
  end
end