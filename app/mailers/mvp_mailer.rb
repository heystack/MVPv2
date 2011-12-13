class MvpMailer < ActionMailer::Base
  default :from => "'StkUp Feedback' <feedback@stkup.com>"

  def email_neighbor(topic, contact, from_name, user_email)
    @topic = topic
    @response = @topic.responses.new
    @contact = contact
    @from_name = from_name
    @from_email = @from_name + " via StkUp <feedback@stkup.com>"
    @email = @contact[:email]
    @user_email = user_email
    @form_capable = false
    @host_url = "http://stkup.com"
    # @host_url = "http://localhost:3000"
    @base_url = @host_url + "/topics/" + @topic.id.to_s + "/responses"
    # Validate reply-to email address
    email_regex = /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    @reply_to_email = ( @user_email =~ email_regex ) ? @user_email : "feedback@stkup.com"
    mail( :to => @email,
          :from => @from_email,
          :reply_to => @reply_to_email,
          :bcc => "feedback@stkup.com",
          :subject => @contact[:email_subject])
  end

  def comment_email(contact)
    @contact = contact
    @from_email = @contact[:from_email]
    mail(:to => "feedback@stkup.com", :cc => "nycbrown@gmail.com", :from => @from_email, :subject => "User Comment!")
  end

  def feedback_email(contact)
    @contact = contact
    @from_email = @contact[:from_email]
    mail(:to => "feedback@stkup.com", :cc => "nycbrown@gmail.com", :from => @from_email, :subject => "User Feedback!")
  end

  def suggestion_email(suggestion)
    @suggestion = suggestion
    mail(:to => "feedback@stkup.com", :cc => "nycbrown@gmail.com", :subject => "Topic Suggestion!")
  end

  def stack_request_email(request)
    @request = request
    mail(:to => "feedback@stkup.com", :cc => "nycbrown@gmail.com", :subject => "Stack Request!")
  end
end
