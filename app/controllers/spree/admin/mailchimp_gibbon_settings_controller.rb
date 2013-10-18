module Spree
  class Admin::MailchimpGibbonSettingsController < Spree::Admin::BaseController

    def show
    end

    def update
      Spree::Config.set(params[:preferences])

      respond_to do |format|
        format.html { redirect_to admin_mailchimp_gibbon_settings_path }
      end
    end
  end
end