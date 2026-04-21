require "csv"

[
  { name: "Jason Kopacz", email: "jason@example.com", password: "password123" },
  { name: "Bob Demo",   email: "bob@example.com",   password: "password123" }
].each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.name     = attrs[:name]
    u.password = attrs[:password]
  end
end
puts "Seeded #{User.count} users"

# Seed photos from CSV — do not read CSV at runtime
csv_path = Rails.root.join("photos.csv")
raise "Missing photos.csv — place it in the project root before running db:seed." unless csv_path.exist?

CSV.foreach(csv_path, headers: true) do |row|
  Photo.find_or_create_by!(external_id: row["id"].to_s) do |photo|
    photo.photographer     = row["photographer"]
    photo.photographer_url = row["photographer_url"]
    photo.src_medium       = row["src.medium"]
    photo.source_url       = row["url"]
    photo.alt              = row["alt"]
  end
end
puts "Seeded #{Photo.count} photos"
