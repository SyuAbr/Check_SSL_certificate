class TelegramBotPoller
  def initialize
    @bots = Tag.all.map do |tag|
      {
        token: tag.bot_token,
        bot: Telegram::Bot::Client.new(tag.bot_token)
      }
    end
    @last_update_id = {}
  end

  def start
    threads = @bots.map do |bot_data|
      Thread.new do
        puts "Starting poller for bot with token: #{bot_data[:token]}"
        poll_bot(bot_data[:bot], bot_data[:token])
      end
    end

    threads.each(&:join)
  end

  private

  def poll_bot(bot, token)
    loop do
      options = { timeout: 30 }
      options[:offset] = (@last_update_id[token] || 0) + 1

      updates = bot.get_updates(options)
      handle_updates(bot, updates, token)

      sleep 5
    end
  end

  def handle_updates(bot, updates, token)
    if updates['result']
      updates['result'].each do |update|
        puts "Received update: #{update.inspect}"
        process_update(bot, update, token) if update.dig('message', 'text')
        @last_update_id[token] = update['update_id']
      end
    end
  end

  def process_update(bot, update, token)
    chat_id = update.dig('message', 'chat', 'id')
    text = update.dig('message', 'text')

    tag = Tag.find_by(bot_token: token)
    if tag
      chat = Chat.find_or_create_by(chat_id: chat_id, tag: tag)
      Rails.logger.info "Chat saved: #{chat.inspect}"
    else
      Rails.logger.error("Tag не найден для токена: #{token}")
    end

    case text
    when '/start'
      bot.send_message(chat_id: chat_id, text: "Привет! Это бот Проверятор.")
    else
      bot.send_message(chat_id: chat_id, text: "Сообщение получено.")
    end
  end
end
