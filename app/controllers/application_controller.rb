class ApplicationController < ActionController::Base
  require File.expand_path("../../models/concerns/icca_links.rb", __FILE__)

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_locale
  before_filter :load_cms_pages

  def load_locale
    I18n.locale = params[:locale] || "en"
  end

  def load_cms_pages
    pages = Comfy::Cms::Page

    @about_page       = pages.where(label: I18n.t("about")).includes(:children).first
    @explore_page     = pages.where(label: I18n.t("explore")).first
    @contact_us_page  = pages.where(label: I18n.t("contact_us")).first
    @participate_page = pages.where(label: I18n.t("participate")).includes(:children).first
  end
end
