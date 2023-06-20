extends Node

const dbPath = "./players.json"

const ERR_USER_NOT_FOUND = 50
const ERR_WRONG_USER_OR_PASSWORD = 51

func loadDatabase():
	if FileAccess.file_exists(dbPath):
		var file = FileAccess.open(dbPath, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	else:
		var data = JSON.parse_string('{"users":[]}')
		commitDatabase(data)
		return data

func signup(nickname, email, password):
	var db = loadDatabase()
	if db["users"].size() == 0:
		db["users"].append({"nickname": nickname,"email": email, "password": password})
		commitDatabase(db)
		db = null
		return OK

	if !userExists(nickname, email, db):
		db["users"].append({"nickname": nickname,"email": email, "password": password})
		commitDatabase(db)
		db = null
		return OK
	else:
		db = null
		return ERR_ALREADY_IN_USE

func commitDatabase(data):
	var file = FileAccess.open(dbPath, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	return true

func userExists(nickname, email, db):
	for user in db["users"]:
		if (user["email"] == email || user["nickname"] == nickname):
			return true
	return false

func signin(nickname, password):
	var db = loadDatabase()
	for user in db["users"]:
		if user["nickname"] == nickname:
			if user["password"] == password:
				user.erase("password")
				db = null
				return user
			else:
				db = null
				return ERR_WRONG_USER_OR_PASSWORD
	db = null
	return ERR_USER_NOT_FOUND
