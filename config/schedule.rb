set :output, "/path/to/my/cron_log.log"
set :environment, 'development'

every 1.day, at: '7:00 am' do
 runner "CertificateCheckJob.perform_later"
end


