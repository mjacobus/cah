# frozen_string_literal: true

module Addresses
  class IndexComponent < ApplicationComponent
    attr_reader :addresses

    def initialize(addresses:)
      @addresses = addresses
    end
  end
end
