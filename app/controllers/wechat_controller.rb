class WechatController < ApplicationController
  before_action :set_keys
  before_action :auth_wechat_user, except: [:auth_return, :notify]
  skip_before_action :verify_authenticity_token

  def auth_wechat_user
    unless cookies[:open_id]
      redirect_to auth_url
    end
  end

  def index
    @search = BaseDrugHosp.new
  end

  def result
    scope = BaseDrugHosp
    scope = scope.where('drug_name LIKE ? ', "%#{params[:drug_name]}%") if params[:drug_name].present?
    scope = scope.where('company LIKE ? ', "#{params[:company]}%") if params[:company].present?
    scope = scope.where('city LIKE ? ', "#{params[:city]}%") if params[:city].present?
    scope = scope.where(years: params[:year]) if params[:year].present?
    scope = scope.where('big_class LIKE ? ', "#{params[:big_class]}%") if params[:big_class].present?

    @query = Query.new
    @query.rows = scope.count
    @query.statement = scope.to_sql

    if @query.rows.between?(1, 100)
      @query.total_fee = 10*100
    elsif @query.rows.between?(101, 200)
      @query.total_fee = 20*100
    elsif @query.rows > 200
      @query.total_fee = 30*100
    else
      @query.total_fee = 0
    end

    # 如果为开发环境，只需支付 1 分钱
    if Rails.env.development?
      @query.total_fee = 1
    end
    @query.save

    options = {
        appid: @app_id,
        mch_id: @mch_id,
        nonce_str: SecureRandom.uuid.gsub('-', ''),
        body: '数据查询',
        out_trade_no: @query.id,
        total_fee: @query.total_fee,
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
        nonceStr: SecureRandom.uuid.gsub('-', ''),
        package: "prepay_id=#{@response['xml']['prepay_id']}",
        signType: 'MD5'
    }
    @options[:paySign] = generate_sign(@options)
  end

  def notify
    xml_data = Hash.from_xml(request.raw_post)
    data = xml_data['xml']

    query = Query.find(data['out_trade_no'].to_i)

    if data['total_fee'].to_i === query.total_fee
      query.paid_at = Time.now
      query.post_raw_data = request.raw_post
      query.save
      render text: '<xml><return_code>SUCCESS</return_code><return_msg>OK</return_msg></xml>'
    end
  end

  def auth_return
    code = params[:code]

    url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{@app_id}&secret=#{@app_secret}&code=#{code}&grant_type=authorization_code"
    response = RestClient.get(url)
    json = JSON.parse(response)

    open_id = json['openid']
    cookies[:open_id] = {value: open_id, httponly: true}

    redirect_to wechat_url
  end


  private
  # 生成 payload XML
  def make_payload(options)
    "<xml>#{options.sort.map { |k, v| "<#{k}>#{v}</#{k}>" }.join}<sign>#{generate_sign(options)}</sign></xml>"
  end

  # 生成 sign
  def generate_sign(options)
    query = options.sort.map do |key, value|
      "#{key}=#{value}"
    end.join('&')

    query += '&key=YfP5yCNVzsYffsfy64hmKGuqcl3xop3A'
    Digest::MD5.hexdigest(query).upcase
  end

  def auth_url
    "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{@app_id}&redirect_uri=#{wechat_auth_return_url}&response_type=code&scope=snsapi_userinfo&state=123"
  end

  def set_keys
    @app_id = 'wxcbb786241f2ef879'
    @mch_id = '1228019202'
    @app_secret = '0312da9137d5e5bdc71a14eed8816ffc'
  end

end
