class CertificateMailer < ApplicationMailer
  def valid_certificate_notification(website, user)
    @website = website
    @user = user

    mail(to: @user.email, subject: 'Уведомление о валидности SSL-сертификата')
  end

  def expiring_soon_notification(website, user)
    @website = website
    @user = user

    mail(to: @user.email, subject: 'Предупреждение об истечении SSL-сертификата в ближайшее время')
  end

  def expired_notification(website, user)
    @website = website
    @user = user

    mail(to: @user.email, subject: 'Уведомление об истечении SSL-сертификата')
  end
end
