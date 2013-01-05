module Spree::MailchimpGibbon
  class Config < Spree::Config
    class << self
      def instance
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        MailchimpGibbonConfiguration.find_or_create_by_name("MailchimpGibbon configuration")
      end
    end
  end
end
