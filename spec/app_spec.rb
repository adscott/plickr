require './spec/spec_helper'

describe 'plickr app' do
  before { get '/' }
  subject { last_response }

  it { should be_ok }
end
