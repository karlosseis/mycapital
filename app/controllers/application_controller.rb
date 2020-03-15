class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :set_stockexchange_prefixsymbols
 

      def saluda
          'hola'
        end


    protected

        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :permission_level, :email, :password) }
            devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :permission_level,:email, :password, :current_password, :is_female, :date_of_birth) }
        end

  

  #   private
  #   def set_stockexchange_prefixsymbols
    # @google_prefix = {}

    # @stocks = Stockexchange.all

   #    @stocks.each do |stockexchange| 
   #      @google_prefix[stockexchange.id] = stockexchange.google_prefix
    
   #     end 

  #   end
end
