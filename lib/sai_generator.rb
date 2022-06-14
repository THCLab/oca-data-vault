# frozen_string_literal: true

require 'base64'
require 'json'

require 'digest/blake3'

class SaiGenerator
  def self.call(data)
    'E' +
      Base64.urlsafe_encode64(
        Digest::BLAKE3.digest(data),
        padding: false
      )
  end
end
