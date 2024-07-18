# frozen_string_literal: true

module Addresses
  class IndexComponent < ApplicationComponent
    attr_reader :addresses, :circuit, :congregation

    def initialize(addresses:, circuit: nil, congregation: nil)
      @addresses = addresses
      @circuit = circuit
      @congregation = congregation
    end

    def stats
      @stats ||= StatsComponent.new(addresses:)
    end

    def total_addresses
      @total_addresses ||= addresses.count
    end

    def resolved_addresses
      @resolved_addresses ||= addresses.where(stage: :done).count
    end

    def unresolved_addresses
      @unresolved_addresses ||= total_addresses - resolved_addresses
    end

    def progress_percentage
      (resolved_addresses * 100) / total_addresses
    end
  end
end
