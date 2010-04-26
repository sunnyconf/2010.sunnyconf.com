require File.dirname(__FILE__) + '/../spec_helper'

describe 'Creating a Proposal' do

  it 'shows errors for required fields' do
    visit '/'
    fill_in_fields :proposal, :name  => 'Sunny Thaper',
                              :email => 'sunny@thaper.com'
    click 'Preview Your Proposal'

    page.should have_content('must not be blank')
  end

  it 'can preview a proposal' do
    visit '/'
    fill_in_fields :proposal, :name  => 'Sunny Thaper',
                              :email => 'sunny@thaper.com',
                              :text  => "I'm going to talk about Sunny Thaper"
    click 'Preview Your Proposal'

    page.should have_content('Sunny Thaper')
    page.should have_content('sunny@thaper.com')
    page.should have_content("I'm going to talk about Sunny Thaper")
    Proposal.count.should == 0
  end

  it 'can edit a proposal (after previewing it)' do
    visit '/'
    fill_in_fields :proposal, :name  => 'Sunny Thaper',
                              :email => 'sunny@thaper.com',
                              :text  => "I'm going to talk about Sunny Thaper"
    click 'Preview Your Proposal'
    click 'Edit Proposal'

    fill_in_fields :proposal, :text => "Haha! Different proposal!"
    click 'Preview Your Proposal'

    page.should have_content('Sunny Thaper')
    page.should have_content('sunny@thaper.com')
    page.should have_content("Haha! Different proposal!")
    page.should have_no_content("I'm going to talk about Sunny Thaper")
    Proposal.count.should == 0
  end

  it 'can submit a proposal' do
    visit '/'
    fill_in_fields :proposal, :name  => 'Sunny Thaper',
                              :email => 'sunny@thaper.com',
                              :text  => "I'm going to talk about Sunny Thaper"
    click 'Preview Your Proposal'

    Proposal.count.should == 0

    click 'Submit Proposal'
    # page.should have_content('Thank you for your proposal!') # this *was* working ...

    Proposal.count.should == 1
    Proposal.first.name.should  == 'Sunny Thaper'
    Proposal.first.email.should == 'sunny@thaper.com'
    Proposal.first.text.should  == "I'm going to talk about Sunny Thaper"
  end

  it 'an email is sent after a proposal is submitted' do
    clear_emails

    visit '/'
    fill_in_fields :proposal, :name  => 'Sunny Thaper',
                              :email => 'sunny@thaper.com',
                              :text  => "I'm going to talk about Sunny Thaper"
    click 'Preview Your Proposal'

    sent_emails.should be_empty

    click 'Submit Proposal'

    sent_emails.length.should == 1
    last_email.subject.should == 'Thank you for your SunnyConf proposal'
    last_email.to.should      == 'Sunny Thaper <sunny@thaper.com>'
    last_email.body.should include('Thank you for your SunnyConf proposal')
  end

end
