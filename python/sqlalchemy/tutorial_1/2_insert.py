import db
from sqlalchemy.orm import sessionmaker
import random

# new session
Session = sessionmaker(bind=db.engine)
session = Session()

# adding random data
for t in range(10,20):
    item_id = random.randint(0, 100)
    price = random.randint(20,50)

    tr = db.transactions(t, '2020/05/06', item_id, price)
    session.add(tr)

# save changes in database
session.commit()