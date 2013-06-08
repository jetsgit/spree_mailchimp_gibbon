require 'exceptional'

class Spree::SubscriptionsController < Spree::BaseController

  def create
    @errors = []

    if params[:email].blank?
      @errors << t('missing_email')
    elsif params[:email] !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
      @errors << t('invalid_email_address')
    else
      begin
         @mc_member = gibbon.list_member_info({:id => Spree::Config.get(:mailchimp_list_id), :email_address => params[:email] }) 

	rescue => ex

	   Exceptional.handle ex

      end

      if @mc_member
        @errors << t('that_address_is_already_subscribed')
      else
        begin
           gibbon.list_subscribe({:id => Spree::Config.get(:mailchimp_list_id),:email_address =>  params[:email] }) 

	 rescue => ex

	   Exceptional.handle ex

	 end


      end
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

    def gibbon
	    @gibbon ||= Gibbon.new(Spree::Config.get(:mailchimp_api_key))	
    end

end
