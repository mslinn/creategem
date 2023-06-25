class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'info@myapp.com'
end
