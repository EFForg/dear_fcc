class CivicrmWorker
  def self.subscribe(email, zip_code=nil)
    CivicrmClient.new.import_contact(email: email, zip_code: zip_code)
  end
end
