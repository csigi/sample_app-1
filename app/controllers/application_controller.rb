class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :sign_in, :signed_in?, :signed_in_user, :sign_out,
                :current_user, :current_user=, :current_user?

  before_filter :set_locale, :locale_redirect

  # Every helper method dependent on url_for (e.g. helpers for named
  # routes like root_path or root_url, resource routes like books_path
  # or books_url, etc.) will now automatically include the locale in
  # the query string,
  def url_options
    { locale: I18n.locale }.merge(super)
  end

  private

    def sign_in(user)
      cookies.permanent[:remember_token] = user.remember_token
      # session[:user_id] = user.id
      self.current_user = user
    end

    def signed_in?
      !current_user.nil?
    end

    def signed_in_user
      unless signed_in?
        store_location # to redirect to original page after signin
        redirect_to signin_url, notice: t('flash.sign_in')
      end
    end

    def sign_out
      self.current_user = nil
      cookies.delete(:remember_token)
      # session[:user_id] = nil
    end

    def current_user
      @current_user ||= User.find_by_remember_token(cookies[:remember_token])
      # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_user=(user)
      @current_user = user
    end

    def current_user?(user)
      user == current_user
    end

    def store_location
      session[:return_to] = request.url
    end

    def set_locale
      I18n.locale = if params[:set_locale].present?
        params[:set_locale]
      else
        params[:locale]
      end
    end

    # redirect_action and redirect_controller instance variables exist
    # in case a locale change is made upon an error screen.
    # Rather than redirect back to index, it will now redirect to the
    # appropriate page.
    def locale_redirect
      @redirect_action = redirect_action
      @redirect_controller = redirect_controller
      @page_number = parse_page_number

      if params[:set_locale].present?
        execute_redirect
      end
    end

    def redirect_action
      case action_name
        when 'create' then 'new'
        when 'update' then 'edit'
        else action_name
      end
    end

    def redirect_controller
      case
        when controller_name == 'microposts' && action_name == 'create'
          @redirect_action = 'home'
          'static_pages'
        else controller_name
      end
    end

    def parse_page_number
      if params[:page].present? && params[:page] =~ /^\d+$/
        params[:page]
      else
        nil
      end
    end

    def execute_redirect
      # only_path option used here instead of a full url to protect
      # against unwanted redirects from user-supplied values:
      # http://brakemanscanner.org/docs/warning_types/redirect/
      # redirect_to options, only_path: true
      options = { locale: I18n.locale, only_path: true }
      case
        when @redirect_controller == 'users' && @redirect_action == 'new'
          redirect_to signup_url, options
        when @redirect_controller == 'sessions' && @redirect_action == 'new'
          redirect_to signin_url, options
        else
          options[:controller] = @redirect_controller
          options[:action] = @redirect_action
          options[:page] = @page_number unless @page_number.nil?
          redirect_to options
      end
    end

end
