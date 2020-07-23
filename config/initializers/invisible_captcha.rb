InvisibleCaptcha.setup do |config|
    config.visual_honeypots = false
end

ActiveSupport::Notifications.subscribe('invisible_captcha.spam_caught') do |spam|
    captured_spam = spam.extract_options!
    Rails.logger.info("#{captured_spam} caught!")        
end