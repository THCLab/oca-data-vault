# frozen_string_literal: true

module Services
  class GetRecordService
    attr_reader :db_client

    def initialize(db_client)
      @db_client = db_client
    end

    def call(hashlink)
      record = db_client[:meta].find(_id: hashlink).first
      return unless record
      filepath = ROOT_PATH + '/storage/' + record.fetch('content_hashlink')
      file = File.open(filepath) if File.file?(filepath)

      [record, file]
    end
  end
end
