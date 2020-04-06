# frozen_string_literal: true

module Services
  class GetRecordsService
    attr_reader :db_client

    def initialize(db_client)
      @db_client = db_client
    end

    def call
      records = db_client[:meta].find.to_a
      records.map do |record|
        {
          DRI: record[:_id],
          file: {
            name: record[:filename],
            type: record[:filetype],
            contentDRI: record[:content_hashlink]
          }
        }
      end
    end
  end
end
