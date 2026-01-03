from app import app, db, User

with app.app_context():
    users_to_update = ['me', 'peter']
    for username in users_to_update:
        user = User.query.filter_by(username=username).first()
        if user:
            user.set_password('admin')
            print(f"Password for user '{username}' updated to 'admin'")
        else:
            # Create the user
            user = User(username=username, email=f'{username}@example.com', role='user')
            user.set_password('admin')
            db.session.add(user)
            print(f"User '{username}' created with password 'admin'")
    db.session.commit()