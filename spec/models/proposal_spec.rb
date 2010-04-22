require File.dirname(__FILE__) + '/../spec_helper'

describe Proposal do

  it 'requires a name' do
    Proposal.gen(:name => nil           ).should_not be_valid
    Proposal.gen(:name => ''            ).should_not be_valid
    Proposal.gen(:name => 'Sunny Thaper').should     be_valid
  end

  it 'requires a valid email address' do
    Proposal.gen(:email => nil               ).should_not be_valid
    Proposal.gen(:email => ''                ).should_not be_valid
    Proposal.gen(:email => 'sunny@          ').should_not be_valid
    Proposal.gen(:email => 'sunny@thaper.com').should     be_valid
  end
  
  it 'requires proposal text' do
    Proposal.gen(:text => nil                                   ).should_not be_valid
    Proposal.gen(:text => ''                                    ).should_not be_valid
    Proposal.gen(:text => "I'm going to talk about Sunny Thaper").should     be_valid
  end

end
