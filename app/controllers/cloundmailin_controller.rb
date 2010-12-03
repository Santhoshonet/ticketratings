require "mail"
class CloundmailinController < ApplicationController

  def index
    message = Mail.new(params[:message])

    Rails.logger.log message.subject
    Rails.logger.log message.body.decode

    render :text => "success", :status => 200
  end

end
