require 'services/v1/new_record_service'
require 'services/v1/get_record_service'
require 'services/v1/get_records_service'

require 'sai_generator'
require 'services/v2/new_record_service'
require 'services/v2/get_record_service'

STORAGE_PATH = File.join(ROOT_PATH, 'storage')
MONGODB_URI = ENV['MONGODB_URI'] || 'mongodb:27017'
