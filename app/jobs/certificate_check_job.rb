
class CertificateCheckJob < ApplicationJob
  queue_as :default

  def perform
    websites = Website.all

    websites.each do |website|
      send_valid_notification(website) if valid_certificate?(website)
      send_expired_notification(website) if expired?(website)
      send_expiring_soon_notification(website) if expiring_soon?(website)

    end
  end

  private

  def valid_certificate?(website)
    client = HTTPClient.new
    client.ssl_config.set_trust_ca('/etc/ssl/certs/ca-certificates.crt')

    response = client.get(website.url)
    cert = response.peer_cert

    false unless cert
  end

  def expiring_soon?(website)
    warning_days = ENV['CERTIFICATE_EXPIRATION_WARNING_DAYS'].to_i
    website.certificate_expiration.present? && website.certificate_expiration <= Date.today + warning_days.days
  end

  def expired?(website)
    website.certificate_expiration.present? && website.certificate_expiration <= Date.today
  end
  def send_valid_notification(website)
    user = User.find_by(id: website.user_id)
    return unless user

    users_to_notify(user).each do |notify_user|
      CertificateMailer.valid_certificate_notification(website, notify_user).deliver_now
    end

    message = "Сертификат для сайта #{website.address} действителен."
    send_telegram_notification(message, website.tags)
  end

  def send_expiring_soon_notification(website)
    user = User.find_by(id: website.user_id)
    return unless user

    users_to_notify(user).each do |notify_user|
      CertificateMailer.expiring_soon_notification(website, notify_user).deliver_now
    end

    message = "Предупреждение: срок действия сертификата для сайта #{website.address} истекает через 10 дней."
    send_telegram_notification(message, website.tags)
  end

  def send_expired_notification(website)
    user = User.find_by(id: website.user_id)
    return unless user

    users_to_notify(user).each do |notify_user|
      CertificateMailer.expired_notification(website, notify_user).deliver_now
    end

    message = "Срок действия SSL-сертификата для сайта #{website.address} истек. Пожалуйста, обновите сертификат."
    send_telegram_notification(message, website.tags)
  end
  def users_to_notify(user)
    admins = User.where(role: "Администратор")
    admins += [user] unless user.admin?

  end
  def send_telegram_notification(message, tags)
    Rails.logger.info("Начало выполнения send_telegram_notification с сообщением: #{message} и тегами: #{tags}")

    tags.each do |tags|
      Rails.logger.info("Поиск тега с именем: #{tags.name}")
      tag = Tag.find_by(name: tags.name)

      if tag
        Rails.logger.info("Тег найден: #{tag.name}. Поиск чатов для этого тега.")
        chats = Chat.where(tag: tag)

        Rails.logger.info("Найдено чатов: #{chats.count} для тега: #{tag.name}")
        chats.each do |chat|
          Rails.logger.info("Отправка сообщения в чат с ID: #{chat.chat_id} используя бот-токен: #{tag.bot_token}")
          Telegram::Bot::Client.new(tag.bot_token).send_message(chat_id: chat.chat_id, text: message)
        end
      else
        Rails.logger.warn("Тег с именем #{tag_name} не найден.")
      end
    end

  end

end
