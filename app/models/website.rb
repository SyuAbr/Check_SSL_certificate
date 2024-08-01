class Website < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :address, presence: true, uniqueness: { message: 'Сайт с аналогичным адресом уже добавлен.' }
  validates :certificate_expiration, presence: true
  validate :at_least_one_tag

  before_validation :update_certificate_expiration

  def url
    "https://#{self.address}"
  end

  private

  def at_least_one_tag
    if tags.empty?
      errors.add(:base, 'Выберите хотя бы один тег.')
    end
  end

  def fetch_certificate_expiration
    client = HTTPClient.new
    client.ssl_config.set_trust_ca('/etc/ssl/certs/ca-certificates.crt')

    response = client.get(url)
    cert = response.peer_cert

    cert ? cert.not_after : nil
  end

  def update_certificate_expiration
    if address_changed? || new_record?
      self.certificate_expiration = fetch_certificate_expiration
    end
  end
end
