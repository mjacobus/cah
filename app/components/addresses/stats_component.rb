module Addresses
  class StatsComponent < ApplicationComponent
    attr_reader :addresses

    def initialize(addresses:)
      @addresses = addresses
    end

    def total_addresses
      @total_addresses ||= addresses.count
    end

    def percentage(number)
      ((number.to_f * 100) / total_addresses.to_f).round(2)
    end

    def resolved_addresses
      @resolved_addresses ||= addresses.where(stage: :done).count
    end

    def in_progress_addresses
      @in_progress_addresses ||= addresses.where(stage: :in_progress).count
    end

    def pending_addresses
      @pending_addresses ||= addresses.where(stage: :pending).count
    end
  end
end
