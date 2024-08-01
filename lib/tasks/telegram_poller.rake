namespace :telegram do
  desc "Start Telegram bot polling"
  task poller: :environment do
    puts "Starting Telegram bot polling..."
    require_relative '../../lib/telegram_bot_poller'
    TelegramBotPoller.new.start
    puts "Telegram bot polling started."
  end
end
