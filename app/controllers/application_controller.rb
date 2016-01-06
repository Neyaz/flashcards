class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  private

  def set_locale
    locale = if current_user
               current_user.locale
             elsif params[:user_locale]
               params[:user_locale]
             elsif session[:locale]
               session[:locale]
             else
               http_accept_language.compatible_language_from(I18n.available_locales)
             end

    if locale && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale
    else
      session[:locale] = I18n.locale = I18n.default_locale
    end
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def get_card_by_request_param
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      if current_user.current_block
        @card = current_user.current_block.cards.pending.first
        @card ||= current_user.current_block.cards.repeating.first
      else
        @card = current_user.cards.pending.first
        @card ||= current_user.cards.repeating.first
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
