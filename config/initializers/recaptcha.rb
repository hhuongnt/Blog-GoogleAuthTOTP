Recaptcha.configure do |config|
  config.site_key = ENV["RECAPTCHA_KEY"]
  config.secret_key = ENV["RECAPTCHA_SECRET"]
end
