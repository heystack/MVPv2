class MvpMailer < ActionMailer::Base
  default :from => "'heystack' <communityshare@heystack.com>"

  def email_neighbor(stack, contact, from_name, user_email)
    @stack = stack
    @response = @stack.responses.new
    @contact = contact
    @community = @stack.community_id
    @from_name = from_name
    @from_email = @from_name + " via heystack <communityshare@heystack.com>"
    @email = @contact[:email]
    @user_email = user_email
    @form_capable = false
    @host_url = "http://heystack.com"
    # @host_url = "http://localhost:3000"
    @base_url = @host_url + "/stacks/" + @stack.id.to_s + "/responses"
    # Validate reply-to email address
    email_regex = /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    @reply_to_email = ( @user_email =~ email_regex ) ? @user_email : "communityshare@heystack.com"
    mail( :to => @email,
          :from => @from_email,
          :reply_to => @reply_to_email,
          :bcc => "communityshare@heystack.com",
          :subject => @contact[:email_subject])
  end

  def comment_email(contact)
    @contact = contact
    @from_email = @contact[:from_email]
    mail(:to => "communityshare@heystack.com", :cc => "nycbrown@gmail.com", :from => @from_email, :subject => "User Comment!")
  end

  def feedback_email(contact)
    @contact = contact
    @from_email = @contact[:from_email]
    mail(:to => "communityshare@heystack.com", :cc => "nycbrown@gmail.com", :from => @from_email, :subject => "User Feedback!")
  end

  def suggestion_email(suggestion)
    @suggestion = suggestion
    mail(:to => "communityshare@heystack.com", :cc => "nycbrown@gmail.com", :subject => "Stack Suggestion!")
  end

  def stack_request_email(request)
    @request = request
    mail(:to => @request[:from_email], :bcc => "communityshare@heystack.com", :subject => "Thanks for your Stack Request!")
  end

  def outlier_email(stack, value, user)
    @stack = stack
    @value = value
    @user = user
    mail(:to => "communityshare@heystack.com", :cc => "nycbrown@gmail.com", :subject => "Outlier on " + @stack.name + ": " + @value.to_s)
  end

  def subscribe_email(user)
    @user = user
    mail(:to => @user.email, :bcc => "communityshare@heystack.com", :subject => "Welcome to the heystack community!")
  end

  def reply_to_comment(comment, reply)
    @comment = comment
    @commenter = User.find_by_id(@comment.user_id)
    @reply = reply
    @replier = User.find_by_id(@reply.user_id)
    @stack = Stack.find_by_id(@comment.stack_id)
    @subject = @replier.name + " just replied to your heystack post!"
    mail(:to => @commenter.email, :bcc => "communityshare@heystack.com", :subject => @subject)
  end
end
