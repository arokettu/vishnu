# frozen_string_literal: true
#
# The Vishnu class generates the avatar URL provided by the libravatar
# web service at https://www.libravatar.org
#
# Users may associate their avatar images with multiple OpenIDs and Emails.
#
# Original Author:: Kang-min Liu (http://gugod.org/)
# Fork Author:: Anton Smirnov (https://sandfox.me/)
# Copyright:: Copyright (c) 2011 Kang-min Liu
# License:: MIT
# Contributors:: https://github.com/sandfoxme/vishnu/graphs/contributors
#

require_relative 'vishnu/version'

require 'digest/md5'
require 'digest/sha2'
require 'uri'
require 'resolv'

class Vishnu
  attr_accessor :email, :openid, :size, :default, :https

  # The options should contain :email or :openid values.  If both are
  # given, email will be used. The value of openid and email will be
  # normalized by the rule described in https://wiki.libravatar.org/api/
  #
  # List of option keys:
  #
  # - :email
  # - :openid
  # - :size An integer ranged 1 - 512, default is 80.
  # - :https Set to true to serve avatars over SSL
  # - :default URL to redirect missing avatars to, or one of these specials:
  #   "404", "mm", "identicon", "monsterid", "wavatar", "retro"
  #
  def initialize(email: nil, openid: nil, size: nil, default: nil, https: nil)
    @email   = email
    @openid  = openid
    @size    = size
    @default = default
    @https   = https
  end

  # All the values which are different between HTTP and HTTPS methods.
  PROFILES = {
    http: {
      scheme: 'http://',
      host:   'cdn.libravatar.org',
      srv:    '_avatars._tcp.',
      port:   80,
    }.freeze,
    https: {
      scheme: 'https://',
      host:   'seccdn.libravatar.org',
      srv:    '_avatars-sec._tcp.',
      port:   443,
    }.freeze
  }.freeze

  # Generate the libravatar URL
  def url
    id =
      if @email
        Digest::MD5.hexdigest(normalize_email(@email))
      else
        Digest::SHA2.hexdigest(normalize_openid(@openid))
      end

    size    = "s=#{@size}"    if @size
    default = "d=#{@default}" if @default

    # noinspection RubyScope
    # ok for them to be nil
    query = [size, default].reject(&:!).join('&')
    query = "?#{query}" unless query == ''

    base_url = get_base_url + '/avatar/'

    base_url + id + query
  end

  alias_method :to_s, :url

  private

  def profile
    PROFILES[@https ? :https : :http]
  end

  def get_target_domain
    if @email
      @email.split('@')[1]
    else
      URI.parse(@openid).host
    end
  end

  # Grab the DNS SRV records associated with the target domain,
  # and choose one according to RFC2782.
  def srv_lookup
    Resolv::DNS.open do |dns|
      resources = dns.getresources(
        profile[:srv] + get_target_domain,
        Resolv::DNS::Resource::IN::SRV
      ).to_a

      return [nil, nil] unless resources.any?

      min_priority = resources.map(&:priority).min
      resources.delete_if { |r| r.priority != min_priority }

      weight_sum = resources.inject(0) { |sum, r| sum + r.weight }.to_f

      resource = resources.max_by do |r|
        if r.weight == 0
          0
        else
          rand**(weight_sum / r.weight)
        end
      end

      return sanitize_srv_lookup(resource.target.to_s, resource.port)
    end
  end

  def get_base_url
    target, port = srv_lookup

    if target && port
      port_fragment = port != profile[:port] ? ':' + port.to_s : ''
      profile[:scheme] + target.to_s + port_fragment
    else
      profile[:scheme] + profile[:host]
    end
  end

  def sanitize_srv_lookup(hostname, port)
    unless hostname.match(/^[0-9a-zA-Z\-.]+$/) && 1 <= port && port <= 65_535
      return [nil, nil]
    end

    [hostname, port]
  end

  def normalize_email(email)
    email.downcase
  end

  # Normalize an openid URL following the description on libravatar.org
  def normalize_openid(url)
    parsed_url = URI.parse(url)
    parsed_url.host   = parsed_url.host.downcase
    parsed_url.scheme = parsed_url.scheme.downcase
    if parsed_url.path == '' && parsed_url.fragment.nil?
      parsed_url.path = '/'
    end

    parsed_url.to_s
  end
end
