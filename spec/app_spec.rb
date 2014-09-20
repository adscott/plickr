require './spec/spec_helper'

describe 'plickr app' do
  let(:route) { '/' }
  let(:users) { 'developer:tester:cheesemaker' }
  let(:secret) { 'foobar' }

  before do
    allow(Conf).to receive(:value).and_return('default')
    allow(Conf).to receive(:value).with('USERS').and_return(users)
    allow(Conf).to receive(:value).with('SECRET').and_return(secret)
    allow(Conf).to receive(:value).with('MEMCACHIER_SERVERS').and_return(nil)
    get route
  end

  subject { last_response }

  it { should be_ok }

  describe 'when using a valid secret' do
    let(:route) { '/lyJWuXv_jiGCSQDamWy7NM5FNXHPno0r7n8prtuY-zo/' }

    it { should be_ok }

    describe 'when examining response body' do
      subject { last_response.body }

      it { should include 'https://farm4.staticflickr.com/3845/15088320129_54c7175ac2_q.jpg' }
    end
  end

  describe 'using an invalid secret' do
    let(:route) { '/zXb2_BVXnAHBxg8Ub0sM2b-P7VmsbxePqJpxG_syNT8/' }

    it { should be_not_found }
  end
end
