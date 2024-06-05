module Addresses
  class StatsComponent < ApplicationComponent
    attr_reader :addresses

    def initialize(addresses:)
      @addresses = addresses
    end

    def total_addresses
      @total_addresses ||= addresses.count
    end

    def verified_addresses
      @verified_addresses ||= addresses.where(verified: true).count
    end

    def resolved_addresses
      @resolved_addresses ||= addresses.where(resolved: true).count
    end

    def unresolved_addresses
      @unresolved_addresses ||= total_addresses - resolved_addresses
    end

    def progress_percentage
      ((resolved_addresses.to_f * 100) / total_addresses.to_f).round(2)
    end
  end
end
