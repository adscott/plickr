require './spec/spec_helper'

describe 'plickr app' do
  let(:route) { '/' }
  let(:users) { 'developer:tester:cheesemaker' }
  let(:secret) { 'foobar' }

  before do
    allow(ENV).to receive(:[]).with('users').and_return(users)
    allow(ENV).to receive(:[]).with('secret').and_return(secret)
    get route
  end
  subject { last_response }

  it { should be_ok }

  describe 'using a valid secret' do
    let(:route) { '/972256b97bff8e21824900da996cbb34ce453571cf9e8d2bee7f29aedb98fb3a/' }

    it { should be_ok }
  end

  describe 'using an invalid secret' do
    let(:route) { '/cd76f6fc15579c01c1c60f146f4b0cd9bf8fed59ac6f178fa89a711bfb32353f/' }

    it { should be_not_found }
  end
end
