class AdminMailer < ApplicationMailer
  default from: 'noreply@storypro.io', to: ENV['RACK_NOTIFICATIONS_EMAIL']

  def rack_attack_notification(name, start, finish, request_id, remote_ip, path)
    @name = name
    @start = start
    @finish = finish
    @request_id = request_id
    @remote_ip = remote_ip
    @path = path

    mail(subject: "[Rack::Attack][Blocked] remote_ip: #{remote_ip}")
  end
end
