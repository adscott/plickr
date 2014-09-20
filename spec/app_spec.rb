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
    let(:route) { '/lyJWuXv_jiGCSQDamWy7NM5FNXHPno0r7n8prtuY-zo/' }

    it { should be_ok }
  end

  describe 'using an invalid secret' do
    let(:route) { '/zXb2_BVXnAHBxg8Ub0sM2b-P7VmsbxePqJpxG_syNT8/' }

    it { should be_not_found }
  end
end
