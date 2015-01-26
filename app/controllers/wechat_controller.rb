class WechatController < ApplicationController
  before_action :set_keys

  def auth_url
    "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{@app_id}&redirect_uri=#{wechat_auth_return_url}&response_type=code&scope=snsapi_userinfo&state=123"
  end

  def auth_return
    code = params[:code]

    url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{@app_id}&secret=#{@app_secret}&code=#{code}&grant_type=authorization_code"
    response = RestClient.get(url)

    Rails.logger.info(response)

    open_id = response['openid']
    cookies[:open_id] = {value: open_id, httponly: true}

    redirect_to wechat_url
  end

  def index
    @search = BaseDrugHosp.new

    if cookies[:open_id]
      options = {
          appid: @app_id,
          mch_id: @mch_id,
          nonce_str: SecureRandom.uuid.gsub('-', ''),
          body: 'test',
          out_trade_no: '10001',
          total_fee: 1,
          spbill_create_ip: request.remote_ip,
          notify_url: wechat_notify_url,
          trade_type: 'JSAPI',
          openid: cookies[:open_id]
      }
      @payload = make_payload(options)
      response = RestClient::Request.execute(
          {
              method: :post,
              url: 'https://api.mch.weixin.qq.com/pay/unifiedorder',
              payload: @payload,
              headers: {content_type: 'application/xml'}
          }
      )
      @response = Hash.from_xml(response)

      @options = {
          appId: @app_id,
          timeStamp: Time.now.to_i.to_s,
          nonceStr: @response['xml']['nonce_str'],
          package: "prepay_id=#{@response['xml']['prepay_id']}",
          signType: 'MD5'
      }
      @options[:paySign] = generate_sign(@options)
    else
      redirect_to auth_url
    end

  end

  private
  def make_payload(options)
    "<xml>#{options.sort.map { |k, v| "<#{k}>#{v}</#{k}>" }.join}<sign>#{generate_sign(options)}</sign></xml>"
  end

  def generate_sign(options)
    query = options.sort.map do |key, value|
      "#{key}=#{value}"
    end.join('&')

    query += '&key=YfP5yCNVzsYffsfy64hmKGuqcl3xop3A'
    Digest::MD5.hexdigest(query).upcase
  end

  def set_keys
    @app_id = 'wxcbb786241f2ef879'
    @mch_id = '1228019202'
    @app_secret = '0312da9137d5e5bdc71a14eed8816ffc'
  end

end
