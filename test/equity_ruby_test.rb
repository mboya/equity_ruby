require 'test_helper'

class EquityRubyTest < Minitest::Test
	BASE_SANDBOX_URL = "https://api.equitybankgroup.com/identity/v1-sandbox/token"
  BASE_SANDBOX_AIRTIME_URL = "https://api.equitybankgroup.com/transaction/v1-sandbox/airtime"
  PAYMENT_URL = "https://api.equitybankgroup.com/transaction/v1-sandbox/payments"
  PAYMENT_STATUS_URL = "https://api.equitybankgroup.com/transaction/v1-sandbox/payments"


  def test_that_it_has_a_version_number
    refute_nil ::EquityRuby::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_can_access_gem
  	key = "THGxQontAh0rQzmhV3AL8n3Dxesmxn1W"
  	secret = "WnOuo23gTiqm6jhL"

  	assert EquityRuby::Client.new(key, secret)
  end

  def test_can_get_token
  	key = "THGxQontAh0rQzmhV3AL8n3Dxesmxn1W"
  	secret = "WnOuo23gTiqm6jhL"

  	stub = stub_request(:post, "#{BASE_SANDBOX_URL}").
		  with(:body => {"grant_type"=>"password", "password"=>"pass", "username"=>"user"},
		       :headers => {'Authorization'=>'Basic VEhHeFFvbnRBaDByUXptaFYzQUw4bjNEeGVzbXhuMVc6V25PdW8yM2dUaXFtNmpoTA==', 'Content-Type'=>'application/x-www-form-urlencoded'}).
		  to_return(:status => 200, body: { access_token: "ASQyHkWGK9Ix4FUkRgeMxYDglbew" }.to_json, :headers => {})

  	enc = EquityRuby::Client.new(key, secret)
  	resp = JSON.parse(enc.get_merchant_token('user', 'pass'))

  	assert stub
  	assert_equal "ASQyHkWGK9Ix4FUkRgeMxYDglbew", resp["access_token"]
  end

  def test_can_purchase_airtime
  	key = "THGxQontAh0rQzmhV3AL8n3Dxesmxn1W"
  	secret = "WnOuo23gTiqm6jhL"

  	token = "ASQyHkWGK9Ix4FUkRgeMxYDglbew"

  	stub = stub_request(:post, "#{BASE_SANDBOX_AIRTIME_URL}").
					  with(:body => "customer[mobileNumber]=724539664&airtime[amount]=20&airtime[reference]=airtime&airtime[telco]=safaricom",
					       :headers => {'Authorization'=>"Bearer #{token}", 'Content-Type'=>'application/json'}).
					  to_return(:status => 200, :body => {referenceNumber: "123", status: "Success", rrn: "7218467"}.to_json, :headers => {})

  	enc = EquityRuby::Client.new(key, secret)
  	resp = JSON.parse(enc.purchase_airtime(token, '724539664', '20', 'airtime', 'safaricom'))

  	assert_requested stub
    assert_equal "123", resp["referenceNumber"]
  end

  def test_can_create_payment
    key = "THGxQontAh0rQzmhV3AL8n3Dxesmxn1W"
    secret = "WnOuo23gTiqm6jhL"

    token = "ASQyHkWGK9Ix4FUkRgeMxYDglbew"

    stub = stub_request(:post, "#{PAYMENT_URL}").
            with(:body => "customer[mobileNumber]=724539664&transaction[amount]=2000&transaction[description]=create%20payment&transaction[type]=payment&transaction[auditNumber]=1234",
                 :headers => {'Authorization'=>"Bearer #{token}", 'Content-Type'=>'application/json'}).
            to_return(status: 200, body: {transactionRef: "123456"}.to_json, headers: {})

    enc = EquityRuby::Client.new(key, secret)
    resp = JSON.parse(enc.create_payment(token, '724539664', '2000', 'create payment', 'payment', '1234'))

    assert_requested stub
    assert_equal "123456", resp["transactionRef"]
  end

  def test_can_get_payment_status
    key = "THGxQontAh0rQzmhV3AL8n3Dxesmxn1W"
    secret = "WnOuo23gTiqm6jhL"

    token = "ASQyHkWGK9Ix4FUkRgeMxYDglbew"

    stub = stub_request(:get, "#{PAYMENT_STATUS_URL}/12345").
            with(:headers => {'Authorization'=>"Bearer #{token}", 'Content-Type'=>'application/json'}).
            to_return(:status => 200, :body => {transactionReference: "1234", status: "Success", amount: "2000.00", mobileNumber: "2547630000000"}.to_json, :headers => {})

    enc = EquityRuby::Client.new(key, secret)
    resp = JSON.parse(enc.get_payment_status(token, '12345'))

    assert_requested stub
    assert_equal "Success", resp["status"]
  end
end


  
  
  