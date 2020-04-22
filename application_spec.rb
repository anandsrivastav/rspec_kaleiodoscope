require 'selenium-webdriver'
require 'byebug'
require 'rspec'
require 'factory_bot'
require '../rspec/rspec_helper.rb'
require '../rspec/factory.rb'
require 'csv'

describe "User Sign In Scenario" do

  before(:each) do
    # Open chrome browser
    @driver = Selenium::WebDriver.for :chrome
    # Describe base URL
    @base_url = "https://app-dev.mykaleidoscope.com"
    # Maximize the window of browser
    @driver.manage.window.maximize
    # Implicit wait
    #@driver.manage.timeouts.implicit_wait = 80
  end

  context "Sign in with valid data" do      
    CSV.foreach("../rspec/users.csv", {headers: true, header_converters: :symbol}) do |row|
      it "User #{row[:username]} signed in successfully" do
        CSV.open("../rspec/report.csv", "a") do |csv|
          csv << ["serial", "username","password", "login_step", "applications_list_step", "application_show_step"] if row[:serial]=='1'          
          @driver.get(@base_url + "/login")
          sleep 10

          @driver.find_element(name: 'email').send_keys row[:username]
          @driver.find_element(name: 'password').send_keys row[:password]
          @driver.find_element(class: "button-actions").find_element(tag_name: 'input').submit();
          sleep 10
          row[:login_step] = @driver.current_url == "#{@base_url}/role" || "#{@base_url}/TacobellTestPrivatemarketPlace" ? 'P' : 'F'
          
          @driver.find_elements(:xpath, "//button")[-1].click rescue nil
          sleep 5
          application_list_page_heading   =  @driver.find_elements(tag_name: "h3")[0].text rescue nil
          row[:applications_list_step]    =  application_list_page_heading && application_list_page_heading.include?("Welcome Back") ?    'P' : 'F'

          @driver.find_element(:xpath, "//tbody//td//a").click rescue nil
          sleep 5
          application_show_page_heading =  @driver.find_elements(tag_name:"h3")[0].text rescue nil
          row[:application_show_step]   =  application_show_page_heading && application_show_page_heading.include?("Scoring Instructions") ? 'P' : 'F'

          csv << row 

        end   
      end
    end
  end

  after(:each) do  
    @driver.close();
  end

  after(:all) do
    File.rename("report.csv", "report-#{Time.now.strftime("%d-%m-%y-%s")}.csv")
  end

end