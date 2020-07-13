class ApplicationController < ActionController::Base
  require File.expand_path("../../models/concerns/icca_links.rb", __FILE__)

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :load_locale
  before_action :load_cms_pages

  def load_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || "en"
  end

  def load_cms_pages
    pages = Comfy::Cms::Page
    site  = Comfy::Cms::Site.find_by_locale(I18n.locale)

    @explore_page     = pages.find_by_slug_and_site_id("explore", site.id)
    @contact_us_page  = pages.find_by_slug_and_site_id("contact-us", site.id)
    @about_page       = pages.where(slug: "about", site: site).includes(:children).first
    @participate_page = pages.where(slug: "participate", site: site).includes(:children).first
  end
end
