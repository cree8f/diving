from app import app, db, User

with app.app_context():
    # Find the admin user
    admin = User.query.filter_by(username='admin').first()
    if admin:
        admin.set_password('admin')
        db.session.commit()
        print("Admin password updated to 'admin'")
    else:
        print("Admin user not found")