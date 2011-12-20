class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def help
      Help.instance
  end

  class Help
    include Singleton
    include ActionView::Helpers::TextHelper
  end
end
