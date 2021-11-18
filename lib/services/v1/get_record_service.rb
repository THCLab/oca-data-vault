# frozen_string_literal: true

module Services
  module V1
    class GetRecordService
      attr_reader :db_client

      def initialize(db_client)
        @db_client = db_client
      end

      def call(hashlink)
        record = db_client[:meta].find(_id: hashlink).first || db_client[:meta].find(content_hashlink: hashlink).first
        return unless record
        filepath = File.join(STORAGE_PATH, record.fetch('content_hashlink'))
        file = File.open(filepath) if File.file?(filepath)

        [record, file]
      end
    end
  end
end
