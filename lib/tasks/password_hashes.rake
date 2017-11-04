namespace :password_hashes do
  desc "Load password hashes in batches of 100"

  task load: :environment do
    puts "Starting import of file"
    client
    load_dump('/home/')
  end

  def load_dump(dir)
    Dir.entries(dir).each do |dump|
      next if dump =~ /^\.\.?$/
      f = File.open(File.join(dir, dump))
      hashes = f.readlines
      hashes.each do |hash|
        insert_entitity(hash)
      end
    end
  end

  def client
    client ||= Azure::Storage.setup(:storage_account_name => 'passwordmatch', :storage_access_key => 'key')
  end

  def tables_getter
    Azure::Storage::Table::TableService.new
  end

  def create_table_er
    tables_getter.create_table('breachedpasswords')
  end

  def insert_entitity(hash)
    entity = { PartitionKey: hash.strip[0,4], Matched: 'false', RowKey: hash.strip }
    # insert_or_update doesnt seem to work urgghh rescue everything
    tables_getter.insert_entity('breachedpasswords', entity) rescue nil
  end
end
