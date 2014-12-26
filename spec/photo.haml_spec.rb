require 'haml'
require 'nokogiri'
require 'ostruct'
require './models/media'

describe 'photo.haml' do
  subject { Nokogiri::HTML.fragment(Haml::Engine.new(File.read('views/photo.haml')).render(OpenStruct.new(locals))) }
  let(:photo) { Media.new(id: '1234', url: 'http://someurl.com/url', thumbnail: 'http://somethumb.com/thumb')}
  let(:locals) { {photo: photo, previous_photo: nil, next_photo: nil} }

  it { expect(subject.css('img')[0][:src]).to eq 'http://someurl.com/url' }
  it { expect(subject.css('a.previous')).to be_empty }
  it { expect(subject.css('a.next')).to be_empty }

  describe 'when there is a previous photo' do
    let(:locals) { {photo: photo, previous_photo: 'http://previousurl.com/previous'} }
    it { expect(subject.css('a.previous')[0][:href]).to eq 'http://previousurl.com/previous' }
  end

  describe 'when there is a next photo' do
    let(:locals) { {photo: photo, next_photo: 'http://nexturl.com/next'} }
    it { expect(subject.css('a.next')[0][:href]).to eq 'http://nexturl.com/next' }
  end
end
