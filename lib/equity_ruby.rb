require "equity_ruby/version"
require 'httparty'
require 'pry'
require 'base64'

module EquityRuby
  # Your code goes here...
  class Client
    BASE_SANDBOX_TOKEN_URL = "https://api.equitybankgroup.com/identity/v1-sandbox/token"
    BASE_SANDBOX_AIRTIME_URL = "https://api.equitybankgroup.com/transaction/v1-sandbox/airtime"
    PAYMENT_URL = "https://api.equitybankgroup.com/transaction/v1-sandbox/payments"
    PAYMENT_STATUS_URL = "https://api.equitybankgroup.com/transaction/v1-sandbox/payments"


    def initialize consumer_key, consumer_secret
      @auth_encoded = encode_string(consumer_key, consumer_secret)
    end

    def get_merchant_token username, password, grant_type="password"
      body = {username: username, password: password, grant_type: grant_type}
      headers = {"Content-Type" => "application/x-www-form-urlencoded", "Authorization" => "Basic #{@auth_encoded}"}
      response = HTTParty.post("#{BASE_SANDBOX_TOKEN_URL}", :headers => headers, body: body)
    end

    # Transactions
    def purchase_airtime token, number, amount, reference, telco
      body = {customer: {mobileNumber: number}, airtime: {amount: amount, reference: reference, telco: telco}}
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"}
      response = HTTParty.post("#{BASE_SANDBOX_AIRTIME_URL}", :headers => headers, body: body)
    end

    def create_payment token, number, amount, description, type, auditNumber
      body = {customer: {mobileNumber: number}, transaction: {amount: amount, description: description, type: type, auditNumber: auditNumber}}
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"}
      response = HTTParty.post("#{PAYMENT_URL}", :headers => headers, body: body)
    end

    # def online_remittance token
    #   body = {}
    #   headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"}
    #   response = HTTParty.post("", headers: headers, body: body)
    # end
 
    def get_payment_status token, transaction_id
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"}
      response = HTTParty.get("#{PAYMENT_STATUS_URL}/#{transaction_id}", headers: headers)
    end

    private
      def encode_string consumer_key, consumer_secret
        enc = Base64.encode64("#{consumer_key}:#{consumer_secret}")
        enc.delete!("\n")
      end
  end
end
