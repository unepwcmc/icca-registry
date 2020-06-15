module CmsHelper
  include BemHelper

  def cms_page page, current_page
    el = 'vertical-nav__element'
    modifiers = [].tap { |m|
      if current_page == page
        m << 'active'
        m << 'selected'
      end
    }

    link_to(page.label, cms_page_path(page), class: bem(el, *modifiers))
  end

  def cms_page_path page
    File.join('/', page.site.path, page.full_path)
  end

  def link_to_cms_page icca_site, site
    page = icca_site.pages.where(site_id: site.id).first

    if page
      link_to(
        "Edit CMS page",
        edit_comfy_admin_cms_site_page_path(site_id: site, id: page.id),
        class: "btn btn-default"
      )
    else
      ""
    end
  end

  def link_to_destroy icca_site
    if icca_site.pages.any?
      ""
    else
      link_to(
        "Destroy",
        admin_icca_site_path(icca_site),
        method: :delete,
        class: "btn btn-default"
      )
    end
  end

  def english_site
    Comfy::Cms::Site.find_by_locale("en")
  end
end
