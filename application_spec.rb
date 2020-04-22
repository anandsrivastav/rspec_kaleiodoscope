require 'selenium-webdriver'
require 'byebug'
require 'rspec'


describe "User Sign In Scenario" do

  before(:each) do
    # Open chrome browser
    @driver = Selenium::WebDriver.for :chrome
    # Describe base URL
    @base_url = "https://app-dev.mykaleidoscope.com"
    # Maximize the window of browser
    @driver.manage.window.maximize
    # Implicit wait
    @driver.manage.timeouts.implicit_wait = 80
  end

  #def wait_for(seconds = 50)
  #end

  context "Sign in with valid data" do
    it "User signed in successfully" do
      @driver.get(@base_url + "/login")
      sleep 10
      @driver.find_element(name: 'email').send_keys "test6726@fakemail.com"
      @driver.find_element(name: 'password').send_keys "Ashish@1234"
      @driver.find_element(class: "button-actions").find_element(tag_name: 'input').submit();
      sleep 10
      expect(@driver.current_url).to eq "#{@base_url}/role"       
    end
  end

  after(:each) do
    @driver.close();
  end

end