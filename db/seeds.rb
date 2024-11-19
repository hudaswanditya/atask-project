Team.create(name: "IT Department")
User.create(username: "john", password: "password", team: Team.first)
User.create(username: "jane", password: "password", team: Team.first)

# Internet connection required
Stock.sync_from_api