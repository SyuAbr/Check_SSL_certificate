# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"
require 'telegram/bot'
Rails.application.load_tasks


namespace :telegram do
  namespace :bot do
    task poller: :environment do
      Telegram.bots_config.each do |bot_key, bot|
        Thread.new do
          Telegram::Bot::Client.run(bot[:token]) do |bot|
            bot.listen do |message|
              Telegram.bots_controller.new.process(bot, message)
            end
          end
        end
      end
      sleep
    end
  end
end
