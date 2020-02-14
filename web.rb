require 'roda'
require 'services/new_record_service'

class Web < Roda
  plugin :json

  route do |r|
    r.root do
      {
        data: 'Hello world'
      }
    end

    r.post 'new' do
      service = ::Services::NewRecordService.new
      service.call(r.params)
    end
  end
end
