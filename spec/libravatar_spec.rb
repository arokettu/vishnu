require 'spec_helper'

RSpec.describe Libravatar do
  describe 'Gets urls' do
    it 'gets url for email' do
      expect(Libravatar.new(email: 'user@example.com').url).to                                            eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')
      expect(Libravatar.new(email: 'user@example.com').to_s).to                                           eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')
      expect(Libravatar.new(email: 'USER@ExAmPlE.CoM').url).to                                            eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')
      expect(Libravatar.new(email: 'user@example.com', https: true).url).to                               eq('https://seccdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')
      expect(Libravatar.new(email: 'user@example.com', https: false).url).to                              eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')
      expect(Libravatar.new(email: 'USER@ExAmPlE.CoM', default: 'http://example.com/avatar.png').url).to  eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af?d=http://example.com/avatar.png')
      expect(Libravatar.new(email: 'USER@ExAmPlE.CoM', size: 512, default: 'mm').url).to                  eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af?s=512&d=mm')
    end

    it 'gets url for openid' do
      avatar = Libravatar.new(openid: 'http://example.com/id/Bob')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd')

      avatar = Libravatar.new(openid: 'https://example.com/id/Bob')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/82be86d8b10f6492d0eb3d6475c388044529b9d4ddf7269dec2483601b22d2e1')

      avatar = Libravatar.new(openid: 'hTTp://EXAMPLE.COM/id/Bob')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd')

      avatar = Libravatar.new(openid: 'hTTp://EXAMPLE.COM/id/Bob', size: 512)
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd?s=512')

      avatar = Libravatar.new(openid: 'http://example.com/id/bob')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/84106b275be9a7c69f3b0f77d1d504a794e6d0e4e0a068fa529d869b721f4261')

      avatar = Libravatar.new(openid: 'hTTp://EXAMPLE.COM/ID/BOB')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/10e678f0db6ead293f21fae8adb1407ab039cffc46f39783152770e4628d9c6c')

      avatar = Libravatar.new(openid: 'http://example.com')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/2a1b402420ef46577471cdc7409b0fa2c6a204db316e59ade2d805435489a067')
    end
  end

  describe 'Works correctly inside' do
    it 'sanitizes openid' do
      x = Libravatar.new

      expect(x.send(:normalize_openid, 'HTTP://EXAMPLE.COM/id/Bob')).to   eq('http://example.com/id/Bob')
      expect(x.send(:normalize_openid, 'HTTP://EXAMPLE.COM')).to          eq('http://example.com/')
      expect(x.send(:normalize_openid, 'https://example.com/id/bob')).to  eq('https://example.com/id/bob')
      expect(x.send(:normalize_openid, 'https://eXamPlE.cOm/ID/BOB/')).to eq('https://example.com/ID/BOB/')
    end

    # TODO: mock resolver and move test to Gets Url
    # it 'returns federated avatar' do
    #   avatar = Libravatar.new(:email => 'invalid@catalyst.net.nz')
    #   expect(avatar.to_s).to eq('http://static.avatars.catalyst.net.nz/avatar/f924d1e9f2c10ee9efa7acdd16484c2f')
    # end

    it 'sanitizes SRV lookup result' do
      avatar = Libravatar.new
      expect(avatar.send(:sanitize_srv_lookup, 'hosntame.abcde.fghi.com', 12345)).to    eq(['hosntame.abcde.fghi.com', 12345])
      expect(avatar.send(:sanitize_srv_lookup, 'hosntame.abcde.fghi.com', 65348283)).to eq([nil, nil])
      expect(avatar.send(:sanitize_srv_lookup, 'FNORD IMPUNTK *#(*$#&',   12345)).to    eq([nil, nil])
      expect(avatar.send(:sanitize_srv_lookup, 'FNORD IMPUNTK *#(*$#&',   65348283)).to eq([nil, nil])
    end
  end
end
