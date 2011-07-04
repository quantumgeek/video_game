require "spec_helper"

describe "Users" do
  describe "signup" do
    it "should not make a new user given invalid information" do
      lambda do
        visit sign_up_path
        fill_in "Email", :with => ""
        fill_in "Username", :with => ""
        fill_in "Password", :with => ""
        fill_in "Password confirmation", :with => ""
        click_button
        response.should render_template('users/new')
      end.should_not change(User, :count)
    end
    
    it "should create a new user" do
      lambda do
        visit sign_up_path
        fill_in "Email", :with => "nathan@nathanreale.com"
        fill_in "Username", :with => "user"
        fill_in "Password", :with => "password"
        fill_in "Password confirmation", :with => "password"
        click_button
        # resonse.should render_template('users/new')
      end.should change(User, :count).by(1)
    end
  end
end