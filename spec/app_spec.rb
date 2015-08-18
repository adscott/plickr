require './spec/spec_helper'

describe 'plickr app' do
  use_vcr_cassette

  let(:route) { '/' }
  let(:users) { 'developer:tester:cheesemaker' }
  let(:secret) { 'foobar' }
  let(:digest) { '' }

  class StubCache
    def fetch(key, ttl=nil)
      yield
    end
  end

  before do
    allow(Cache).to receive(:instance).and_return(::StubCache.new)
    allow(Conf).to receive(:value).and_return('default')
    allow(Conf).to receive(:value).with('USERS').and_return(users)
    allow(Conf).to receive(:value).with('SECRET').and_return(secret)
    allow(Conf).to receive(:value).with('MEMCACHIER_SERVERS').and_return(nil)
    get route
  end

  it { expect(last_response).to be_ok }

  it { expect(last_response.body).to include 'If you\'d like access, let Adam know.' }

  describe 'when hitting a digest url' do
    let(:route) { "/#{digest}/"}

    describe 'when the digest is valid' do
      let(:digest) { 'lyJWuXv_jiGCSQDamWy7NM5FNXHPno0r7n8prtuY-zo' }

      it { expect(last_response).to be_redirect }

      describe 'when following redirect' do
        before { follow_redirect! }

        it { expect(last_response).to be_ok }
        it { expect(last_response.body).to include 'https://somefarm.com/5555/image_5678_q.jpg' }

        describe 'when going to a photo page' do
          before { get '/photo/1234' }

          it { expect(last_response).to be_ok }
          it { expect(last_response.body).to include 'https://somefarm.com/5555/image_1234_k.jpg' }
          it { expect(last_response.body).to include '/photo/5678' }
        end
      end
    end

    describe 'using an invalid digest' do
      let(:digest) { 'zXb2_BVXnAHBxg8Ub0sM2b-P7VmsbxePqJpxG_syNT8' }

      it { expect(last_response).to be_not_found }

      describe 'when going to a photo page' do
        before { get '/photo/1234' }

        it { expect(last_response).to be_not_found }
      end
    end
  end
end
