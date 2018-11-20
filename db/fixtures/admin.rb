@admin = {

  "mat.brady@threespot.com": {
    name: "Mat Brady",
    organization: "Threespot",
  },

  "sarah.greene@threespot.com": {
    name: "Sarah Greene",
    organization: "Threespot",
  },

  "ted.whitehead@threespot.com": {
    name: "Ted Whitehead",
    organization: "Threespot",
  },

  "daniel.boggs@threespot.com": {
    name: "Daniel Boggs",
    organization: "Threespot",
  },

  "lewis.francis@threespot.com": {
    name: "Lewis Francis",
    organization: "Threespot",
  },

}

@admin.each do |email, fields|
  Administrator.seed_once(:email) do |s|
    s.email = email
    s.name = fields[:name]
    s.organization = fields[:organization]
  end
end
