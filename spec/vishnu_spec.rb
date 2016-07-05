# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vishnu do
  describe 'Gets urls' do
    before(:each) do
      dns = double('Resolv::DNS')
      allow(Resolv::DNS).to receive(:open).and_yield(dns)
      allow(dns).to receive(:getresources) do |host, type|
        expect(type).to eq(Resolv::DNS::Resource::IN::SRV)

        case host.downcase
        when '_avatars._tcp.federated.com'
          [
            Resolv::DNS::Resource::IN::SRV.new(
              0, 5, 80, 'avatars.federated.com'
            ),
            Resolv::DNS::Resource::IN::SRV.new(
              5, 5, 80, 'not-in-priority.federated.com'
            ),
          ]
        when '_avatars-sec._tcp.federated.com'
          [
            Resolv::DNS::Resource::IN::SRV.new(
              5, 5, 443, 'not-in-priority.federated.com'
            ),
            Resolv::DNS::Resource::IN::SRV.new(
              0, 5, 443, 'avatars.federated.com'
            ),
          ]
        when '_avatars._tcp.custom-federated.com'
          [Resolv::DNS::Resource::IN::SRV.new(
            0, 5, 8080, 'avatars.custom-federated.com'
          )]
        when '_avatars-sec._tcp.custom-federated.com'
          [Resolv::DNS::Resource::IN::SRV.new(
            0, 5, 8043, 'avatars.custom-federated.com'
          )]
        when '_avatars._tcp.nonjunk-federated.com'
          [Resolv::DNS::Resource::IN::SRV.new(
            0, 5, 12345, 'hosntame.abcde.fghi.com'
          )]
        when '_avatars._tcp.junk-federated.com'
          [Resolv::DNS::Resource::IN::SRV.new(
            0, 5, 65348283, 'FNORD IMPUNTK *#(*$#&'
          )]
        when '_avatars._tcp.junk2-federated.com'
          [Resolv::DNS::Resource::IN::SRV.new(
            0, 5, 65348283, 'hosntame.abcde.fghi.com'
          )]
        when '_avatars._tcp.junk3-federated.com'
          [Resolv::DNS::Resource::IN::SRV.new(
            0, 5, 12345, 'FNORD IMPUNTK *#(*$#&'
          )]
        else
          []
        end
      end
    end

    it 'gets url for non federated email' do
      # non-federated
      avatar = Vishnu.new(email: 'user@example.com')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')

      avatar = Vishnu.new(email: 'user@example.com')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')

      avatar = Vishnu.new(email: 'USER@ExAmPlE.CoM')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')

      avatar = Vishnu.new(email: 'user@example.com', https: true)
      expect(avatar.url).to eq('https://seccdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')

      avatar = Vishnu.new(email: 'user@example.com', https: false)
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af')

      avatar = Vishnu.new(email: 'USER@ExAmPlE.CoM', default: 'http://example.com/avatar.png')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af?d=http://example.com/avatar.png')

      avatar = Vishnu.new(email: 'USER@ExAmPlE.CoM', size: 512, default: 'mm')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af?s=512&d=mm')
    end

    it 'gets url for federated email' do
      # federated
      avatar = Vishnu.new(email: 'user@federated.com')
      expect(avatar.url).to eq('http://avatars.federated.com/avatar/d69b469ded547b3ddef720a70c186322')

      # federated secure
      avatar = Vishnu.new(email: 'user@feDeRaTed.cOm', https: true)
      expect(avatar.url).to eq('https://avatars.federated.com/avatar/d69b469ded547b3ddef720a70c186322')

      # federated with custom port
      avatar = Vishnu.new(email: 'USER@cuStOm-feDerated.COM')
      expect(avatar.url).to eq('http://avatars.custom-federated.com:8080/avatar/8df8704e4b556e0684f7c38accdaf517')

      # federated secure with custom port
      avatar = Vishnu.new(email: 'user@custom-federated.com', https: true)
      expect(avatar.url).to eq('https://avatars.custom-federated.com:8043/avatar/8df8704e4b556e0684f7c38accdaf517')
    end

    it 'gets url for non federated openid' do
      avatar = Vishnu.new(openid: 'http://example.com/id/Bob')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd')

      avatar = Vishnu.new(openid: 'https://example.com/id/Bob')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/82be86d8b10f6492d0eb3d6475c388044529b9d4ddf7269dec2483601b22d2e1')

      avatar = Vishnu.new(openid: 'hTTp://EXAMPLE.COM/id/Bob')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd')

      avatar = Vishnu.new(openid: 'hTTp://EXAMPLE.COM/id/Bob', size: 512)
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd?s=512')

      avatar = Vishnu.new(openid: 'http://example.com/id/bob')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/84106b275be9a7c69f3b0f77d1d504a794e6d0e4e0a068fa529d869b721f4261')

      avatar = Vishnu.new(openid: 'hTTp://EXAMPLE.COM/ID/BOB')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/10e678f0db6ead293f21fae8adb1407ab039cffc46f39783152770e4628d9c6c')

      avatar = Vishnu.new(openid: 'http://example.com')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/2a1b402420ef46577471cdc7409b0fa2c6a204db316e59ade2d805435489a067')
    end

    it 'gets url for federated openid' do
      avatar = Vishnu.new(openid: 'http://federated.com/id/user')
      expect(avatar.url).to eq('http://avatars.federated.com/avatar/50ef67971fecacf62abe7f9a002aaf6a26ff5882229a51899439dd4c7ccb9ddd')

      avatar = Vishnu.new(openid: 'http://custom-federated.com/id/user')
      expect(avatar.url).to eq('http://avatars.custom-federated.com:8080/avatar/e2014cf33d71fbf29f6976eab7f9569e7c9eae358cca0ac5b4aa536400a1c9fe')
    end

    it 'sanitizes SRV lookup result' do
      # normal, use received data
      avatar = Vishnu.new(email: 'user@nonjunk-federated.com')
      expect(avatar.url).to eq('http://hosntame.abcde.fghi.com:12345/avatar/d2b338588b00d29e3f37a5ed49244b58')

      # junk, use central service
      avatar = Vishnu.new(email: 'user@junk-federated.com')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/54af4ded7e369f02d8a4bcfcdc227312')

      # junk port, use central service
      avatar = Vishnu.new(email: 'user@junk2-federated.com')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/7f567cad8ea6f851a406c83becee21ba')

      # junk host, use central service
      avatar = Vishnu.new(email: 'user@junk3-federated.com')
      expect(avatar.url).to eq('http://cdn.libravatar.org/avatar/fa085bd0dbf5b9df0b3fd8e39eb65cd0')
    end
  end
end
