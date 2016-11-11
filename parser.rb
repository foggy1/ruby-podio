module Parser

  # Namespaces and chains the parsing methods after initial API call
  def self.parse(scrubable)
    scrubbed = self.scrub(scrubable)
    self.dates_confirmed(scrubbed)
  end

  # Checks field label and retrieves its associated value
  # These are made into key value pairs
  def self.scrub(scrubable)
    scrubbed = scrubable["items"].map do |item|
      clean_args = {}
      item["fields"].each do |field|
        if field["label"] == "Meeting Title" ||
           field["label"] == "Topic Summary"
          clean_args[field["label"]] = field["values"].first["value"].gsub(/<\/?[^>]*>/, "")
        elsif field["label"] == "Meeting Type" || 
              field["label"] == "Priority" ||
              field["label"] == "Scheduling Status" ||
              field["label"] == "Campaign"
          clean_args[field["label"]] = field["values"].first["value"]["text"]
        elsif field["label"] == "Time & Date of Meeting"
          clean_args[field["label"]] = field["values"].first["start_date_utc"]
        elsif field["label"] == "Location"
          clean_args[field["label"]] = field["values"].first["formatted"]
          clean_args["lat"] = field["values"].first["lat"]
          clean_args["lng"] = field["values"].first["lng"]
        end
      end
      clean_args
    end
    # Remove duplicates
    scrubbed.uniq
  end

  # Returns only those items with Date confirmed status
  def self.dates_confirmed(scrubbed)
    scrubbed.select{ |item| item["Scheduling Status"] == "Date confirmed" }
  end

end