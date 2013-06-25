class Spree::SubscriptionsController < Spree::BaseController

  def create
    @errors = []

    if params[:email].blank?
      @errors << t('missing_email')
    elsif params[:email] !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
      @errors << t('invalid_email_address')
    else
      if @mc_member
        @errors << t('that_address_is_already_subscribed')
      else
        begin
          hominid.list_subscribe( Spree::Config[:mailchimp_list_id], params[:email], {}, 'html',
                                  false, false, false, true )

        rescue Hominid::APIError => ex
          @errors << t('that_address_is_already_subscribed')
          logger.warn "SpreeMailChimp: Failed to subscribe user: #{ex.message}\n#{ex.backtrace.join("\n")}"
        end


      end
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def hominid
    @hominid ||= Hominid::API.new(Spree::Config[:mailchimp_api_key])
  end

end
