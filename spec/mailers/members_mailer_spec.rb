require File.join(File.dirname(__FILE__), "..", "spec_helper")

# Move this to your spec_helper.rb.
module MailControllerTestHelper
  # Helper to deliver
  def deliver(action, mail_params = {}, send_params = {})
    MembersMailer.dispatch_and_deliver(action, { :from => "no-reply@webapp.com", :to => "recepient@person.com" }.merge(mail_params), send_params)
    @delivery = last_delivered_mail
  end
end

describe MembersMailer, "#notify_new_password email template" do
  include MailControllerTestHelper
  
  before :each do
    clear_mail_deliveries
    @member = mock(Member)
    @member.stub!(:name).and_return("Peter Pan")
    @new_password = "foo"
    
    stub_constitution!
  end
    
  describe "new password email" do
    
    before do
      MembersMailer.dispatch_and_deliver(:notify_new_password, {}, { :member =>  @member, :new_password=>@new_password})
    end
      
    it "includes welcome phrase and password in email text" do    
      last_delivered_mail.text.should =~ /Dear #{@member.name}/
      last_delivered_mail.text.should =~ /#{@new_password}/            
    end
    
    it "includes login link in email text" do
      last_delivered_mail.text.should =~ %r{http://test.com/login}            
    end
  end
  
  describe "new member email" do
    before do
      MembersMailer.dispatch_and_deliver(:welcome_new_member, {}, { :member =>  @member, :password=>@new_password})
    end
      
    it "includes welcome phrase and password in email text" do          
      last_delivered_mail.text.should =~ /Dear #{@member.name}/
      last_delivered_mail.text.should =~ /#{@new_password}/            
    end
    
    it "includes login link in email text" do
      last_delivered_mail.text.should =~ %r{http://test.com/login}            
    end
      
  end

end