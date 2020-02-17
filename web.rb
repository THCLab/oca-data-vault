require 'roda'
require 'mongo'
require 'services/new_record_service'
require 'services/get_record_service'

class Web < Roda
  plugin :json

  db_client = Mongo::Client.new(
    ['mongodb:27017'], database: 'files_metadata'
  )

  route do |r|
    r.root do
      db_client[:meta].find.to_a
    end

    r.post 'new' do
      service = ::Services::NewRecordService.new(db_client)
      hashlink = service.call(r.params)

      hashlink
    end

    r.get String do |hashlink|
      service = ::Services::GetRecordService.new(db_client)
      record, file = service.call(hashlink)

      response.headers['Content-Disposition'] =
        "attachment; filename=\"#{record[:filename]}.#{record[:filetype]}\""
      file.read
    end
  end
end
