# frozen_string_literal: true

module Services
  module V2
    class GetRecordService
      def call(hashlink)
        filepath = File.join(STORAGE_PATH, hashlink)
        return unless File.file?(filepath)
        File.open(filepath)
      end
    end
  end
end
