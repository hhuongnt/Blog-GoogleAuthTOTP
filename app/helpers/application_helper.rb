module ApplicationHelper
  def post_rate(post)
    return 0 if post.blank?

    rates_sum = post.rates.inject(0) { |sum, rate| sum + rate.value.to_f }
    post.rates.size.positive? ? rates_sum / post.rates.size : 0
  end

  def google_authenticator_qrcode(user)
    user = User.find(user.dig('id'))

    if user.unconfirmed_two_factor?
      user.otp_secret_key = user.generate_totp_secret
      user.save!
      data = user.provisioning_uri
      data = Rack::Utils.escape(data)
      url = "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{data}"
      return image_tag(url, :alt => 'Google Authenticator QRCode')
    end
  end
end
