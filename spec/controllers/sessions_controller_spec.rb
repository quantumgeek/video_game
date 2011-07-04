require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  describe "POST 'create'" do
    context "with invalid data" do
      before(:each) do
        @attr = { :username => "invalid", :password => "invalid" }
      end
      
      it "should re-render the new page" do
        post :create, @attr
        response.should render_template('sessions/new')
      end
    end
    
    context "with valid username and password" do
      before(:each) do
        @user = Factory(:user)
        @attr = { :username => @user.username, :password => @user.password }
      end
      
      it "should sign the user in" do
        post :create, @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      
      it "should redirect to the user's profile page" do
        post :create, @attr
        response.should redirect_to(user_path(@user))
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    it "should sign a user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
end
