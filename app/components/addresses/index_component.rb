# frozen_string_literal: true

module Addresses
  class IndexComponent < ApplicationComponent
    attr_reader :addresses, :circuit, :congregation

    def initialize(addresses:, circuit: nil, congregation: nil)
      @addresses = addresses
      @circuit = circuit
      @congregation = congregation
    end
  end
end
