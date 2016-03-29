# encoding: utf-8

require 'spec_helper'

describe OmniAuth::Strategies::Vkontakte do
  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}) }

  before do
    OmniAuth.config.test_mode = true
  end

  subject do
    args = ['api_key', 'api_secret', @options || {}].compact
    obj = OmniAuth::Strategies::Vkontakte.new(*args).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
    @access_token = double('OAuth2::AccessToken')
    allow(obj).to receive(:access_token).and_return(@access_token)
    allow(@access_token).to receive(:get).and_return(double('OAuth2::Response'))
    allow(@access_token).to receive(:params).and_return({ 'email' => raw_info_hash['email'] })
    obj
  end

  describe 'client options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('vkontakte')
    end

    it 'should have correct site' do
      expect(subject.options.client_options.site).to eq('https://api.vk.com/')
    end

    it 'should have correct authorize url' do
      expect(subject.options.client_options.authorize_url).to eq('https://oauth.vk.com/authorize')
    end

    it 'should have correct token url' do
      expect(subject.options.client_options.token_url).to eq('https://oauth.vk.com/access_token')
    end
  end

  describe 'info' do
    before do
      allow(subject).to receive(:raw_info).and_return(raw_info_hash)
    end

    it 'should returns the nickname' do
      expect(subject.info[:nickname]).to eq(raw_info_hash['nickname'])
    end

    it 'should returns the name' do
      expect(subject.info[:name]).to eq('Павел Дуров')
    end

    it 'should returns the first_name' do
      expect(subject.info[:first_name]).to eq(raw_info_hash['first_name'])
    end

    it 'should returns the last_name' do
      expect(subject.info[:last_name]).to eq(raw_info_hash['last_name'])
    end

    it 'should returns the email' do
      expect(subject.info[:email]).to eq(raw_info_hash['email'])
    end

    it 'should returns the location' do
      expect(subject.info[:location]).to eq('Российская Федерация, Санкт-Петербург')
    end

    it 'should returns the urls' do
      expect(subject.info[:urls]['Vkontakte']).to eq("http://vk.com/#{raw_info_hash['screen_name']}")
    end
  end

  describe 'image_size option' do
    context 'when user has an image' do
      it 'should return image with size specified' do
        @options = { :image_size => 'original' }
        allow(subject).to receive(:raw_info).and_return(
            raw_info_hash.merge({ 'photo_200_orig' => img_url })
        )
        expect(subject.info[:image]).to eq(img_url)
      end

      it 'should return image with size specified' do
        @options = { :image_size => 'original_x2' }
        allow(subject).to receive(:raw_info).and_return(
            raw_info_hash.merge({ 'photo_400_orig' => img_url })
        )
        expect(subject.info[:image]).to eq(img_url)
      end

      it 'should return bigger image when bigger size specified' do
        @options = { :image_size => 'bigger' }
        allow(subject).to receive(:raw_info).and_return(
            raw_info_hash.merge({ 'photo_100' => img_url })
        )
        expect(subject.info[:image]).to eq(img_url)
      end

      it 'should return mini image when mini size specified' do
        @options = { :image_size => 'mini' }
        allow(subject).to receive(:raw_info).and_return(
            raw_info_hash.merge({ 'photo_50' => img_url })
        )
        expect(subject.info[:image]).to eq(img_url)
      end

      it 'should return normal image by default' do
        allow(subject).to receive(:raw_info).and_return(
            raw_info_hash.merge({ 'photo_50' => img_url })
        )
        expect(subject.info[:image]).to eq(img_url)
      end
    end
  end

  describe 'skip_info option' do
    context 'when skip info option is enabled' do
      it 'should not include raw_info in extras hash' do
        @options = { :skip_info => true }
        allow(subject).to receive(:raw_info).and_return({:foo => 'bar'})
        expect(subject.extra[:raw_info]).to eq(nil)
      end
    end
  end

  describe 'request_phase' do
    context 'with no request params set and redirect_url specified' do
      before do
        @options = { :redirect_url => 'http://www.example.com/auth/vkontakte/callback' }
        allow(subject).to receive(:env).and_return({})
        allow(subject).to receive(:request).and_return(
          double('Request', {:params => {}, :scheme => 'https',
                             :url => 'https://oauth.vk.com/authorize',
                             :cookies => {}, :env => {}})
        )
        allow(subject).to receive(:request_phase).and_return(:whatever)
      end

      it 'should not break' do
        expect { subject.request_phase }.not_to raise_error
      end
    end
  end
end

private

def img_url
  'http://cs7001.vk.me/c7003/v7003079/374b/53lwetwOxD8.jpg'
end

def raw_info_hash
  {
    'screen_name' => 'foo_bar',
    'first_name' => 'Павел',
    'last_name' => 'Дуров',
    'nickname' => 'foo_bar',
    'email' => 'foo@example.com',
    'country' => { 'title' => 'Российская Федерация' },
    'city' => { 'title' => 'Санкт-Петербург' },
    'description' => 'Developer',
    'url' => 'example.com/foobar'
  }
end
