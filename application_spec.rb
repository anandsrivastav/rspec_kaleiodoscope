require 'selenium-webdriver'
require 'byebug'
require 'rspec'
require 'factory_bot'
require '../rspec/rspec_helper.rb'
require '../rspec/factory.rb'
require 'csv'

describe "User Sign In Scenario" do

  before(:each) do
    # Create user
    @user = build(:user)
    # Open chrome browser
    @driver = Selenium::WebDriver.for :chrome
    # Describe base URL
    @base_url = "https://app-dev.mykaleidoscope.com"
    # Maximize the window of browser
    @driver.manage.window.maximize
    # Implicit wait
    @driver.manage.timeouts.implicit_wait = 80
  end

  context "Sign in with valid data" do
    it "User #{@user.username} signed in successfully" do      
      @driver.get(@base_url + "/login")
      sleep 10
      @driver.find_element(name: 'email').send_keys @user.username
      @driver.find_element(name: 'password').send_keys @user.password
      @driver.find_element(class: "button-actions").find_element(tag_name: 'input').submit();
      sleep 10
      expect(@driver.current_url).to eq "#{@base_url}/role"       
    end
  end

  after(:each) do
    @driver.find_element(class: 'hamburger-box').click;
    @driver.find_element(:xpath,"//a[@id='header_logout__c']").click;    
    @driver.close();
  end

end