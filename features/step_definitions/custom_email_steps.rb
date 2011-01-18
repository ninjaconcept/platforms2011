Given(/the email queue is empty/) do
  ActionMailer::Base.deliveries.clear
end