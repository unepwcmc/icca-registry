class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_cms_pages

  def load_cms_pages
    pages = Comfy::Cms::Page

    @about_page       = pages.where(label: "About").includes(:children).first
    @participate_page = pages.where(label: "Participate").includes(:children).first
  end
end
