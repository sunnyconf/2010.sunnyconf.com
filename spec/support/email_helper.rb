require 'ostruct'

# Override the SunnyConf#email method for test mode
class SunnyConf
  def email email_address, subject, body
    $sent_emails ||= []
    $sent_emails << OpenStruct.new({
      :to      => email_address,
      :subject => subject,
      :body    => body
    })
  end
end

def sent_emails
  $sent_emails || []
end

def last_email
  $sent_emails.last
end

def clear_emails
  $sent_emails = []
end
