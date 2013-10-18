class Spree::SubscriptionsController < Spree::BaseController

  def create
    @errors = []

    if params[:email].blank?
      @errors << t('missing_email')
    elsif params[:email] !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
      @errors << t('invalid_email_address')
    else
      @mc_member = gibbon.lists.member_info( { id: Spree::Config[:mailchimp_list_id], emails: [{ email: params[:email] }] })
      if @mc_member
        if @mc_member["data"].present?
          if @mc_member["data"].first["status"] == "unsubscribed"
            begin
              gibbon.lists.subscribe( { id: Spree::Config[:mailchimp_list_id], email: { email: params[:email] }, merge_vars: {},
                                        double_optin: false, send_welcome: true } )
            rescue Exception => ex
              @errors << t('that_address_is_already_subscribed')
              logger.debug "SpreeMailChimp: Failed to subscribe user: #{ex.message}\n#{ex.backtrace.join("\n")}"
            end
          else
            @errors << t('that_address_is_already_subscribed')
          end

        end
      elsif @mc_member["errors"].present?
        if @mc_member["errors"].first["code"] != 232
          @errors << t('that_address_is_already_subscribed')
        else
          gibbon.lists.subscribe( { id: Spree::Config[:mailchimp_list_id], email: { email: params[:email] }, merge_vars: {},
                                    double_optin: false, send_welcome: true } )
        end
      end
    end

    respond_to do |format|
      format.js do
        if @errors.empty?
          flash[:success] = Spree.t(:you_have_been_subscribed)
        else
          flash[:error] = @errors.join('. ')
        end
        render 'spree/subscriptions/create'
      end
    end
  end

  private

  def gibbon
    @gibbon ||= Gibbon::API.new(Spree::Config[:mailchimp_api_key])
  end

end
