module SaveObject
  extend ActiveSupport::Concern

  included do
    def save_or_redirect_on_error(object)
      unless object.save
        flash[:error] = object.errors.full_messages.join(', ')
        redirect_to action: :edit
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, SaveObject)