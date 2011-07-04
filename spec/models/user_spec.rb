require 'spec_helper'

describe User do
  before(:each) do
    @attr = Factory.attributes_for(:user)
  end
    
  context "creation" do
    context "username validation" do
      it "should create a new user when given corrent information" do
        User.create!(@attr)
      end
    
      it "should require a username" do
        User.new(@attr.merge(:username => "")).should_not be_valid
      end
    
      it "should reject long usernames" do
        User.new(@attr.merge(:username => "a"*21)).should_not be_valid
      end
    
      it "should reject duplicate usernames" do
        User.create!(@attr)
        User.new(@attr.merge(:email => "other@nathanreale.com")).should_not be_valid
      end
    end
    
    context "email validations" do
      it "should require an email address" do
        User.new(@attr.merge(:email => "")).should_not be_valid
      end
    
      it "should reject invalid email address" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |address|
          User.new(@attr.merge(:email => address)).should_not be_valid
        end
      end
    
      it "should reject duplicate email address" do
        User.create!(@attr)
        User.new(@attr.merge(:name => "other")).should_not be_valid
      end
    
      it "should reject duplicate email address up to case" do
        User.create!(@attr)
        User.new(@attr.merge(:name => "other", :email => @attr[:email].upcase)).should_not be_valid
      end
    end
    
    context "password validation" do
      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
      end
      
      it "should require a matcing password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
      end
      
      it "should reject short passwords" do
        User.new(@attr.merge(:password => "a" * 5, :password_confirmation => "a" * 5)).should_not be_valid
      end
      
      it "should reject long passwords" do
        User.new(@attr.merge(:password => "a" * 41, :password_confirmation => "a" * 41)).should_not be_valid
      end
      
      context "encryption" do
        before(:each) do
          @user = Factory(:user)
        end
        
        it "should respond to password_hash" do
          @user.should respond_to :password_hash
        end 
        
        it "should set the encypted password" do
          @user.password_hash.should_not be_blank
        end
        
      end
    end
  end
  
  context "authentication" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should return nil on username/password mismatch" do
      User.authenticate(@user.username, "wrongpassword").should be_nil
      User.authenticate("wrongusername", @user.password).should be_nil
    end
    
    it "should return the user on email/password match" do
      User.authenticate(@user.username, @user.password).should == @user
    end
    
  end
  
  context "admin attribute" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
end
