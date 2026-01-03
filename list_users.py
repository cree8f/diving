from app import app, db, User

with app.app_context():
    users = User.query.all()
    if users:
        print("Existing users:")
        for user in users:
            print(f"Username: {user.username}, Email: {user.email}, Role: {user.role}")
    else:
        print("No users found in the database.")