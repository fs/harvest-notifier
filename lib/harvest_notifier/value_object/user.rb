# frozen_string_literal: true

module HarvestNotifier
  module ValueObject
    class User
      attr_reader :id, :user_name, :email, :weekly_capacity

      def initialize(data)
        @id = safe_value(data[:id])
        @user_name = safe_value(data[:user_name])
        @email = safe_value(data[:email])
        @weekly_capacity = safe_value(data[:weekly_capacity]).to_i
      end

      def owned_by?(identifier)
        normalize_string(id).include?(normalize_string(identifier))
      end

      private

      def safe_value(value)
        return if value.to_s.strip == ""

        value
      end

      def normalize_string(value)
        value.to_s.gsub(/[^0-9A-Z]/i, "").downcase
      end
    end
  end
end
