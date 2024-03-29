# frozen_string_literal: true

module Services
  module V1
    class GetRecordsService
      attr_reader :db_client

      def initialize(db_client)
        @db_client = db_client
      end

      def call
        records = db_client[:meta].find.to_a
        records.map do |record|
          {
            record_sai: record[:_id],
            file: {
              name: record[:filename],
              type: record[:filetype],
              content_sai: record[:content_hashlink]
            }
          }
        end
      end
    end
  end
end
