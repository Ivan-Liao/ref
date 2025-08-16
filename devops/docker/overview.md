# Commands
1. build
   1. example ... docker build -t ivanliao/todo-app
2. exec
   1. example ... docker exec -u postgres postgres_container_demo createdb postgres_db_demo
   2. example ... docker exec -it postgres_container_demo psql -U postgres -d postgres_db_demo
3. pull
   1. example ... docker pull postgres
4. push
   1. example ... docker push ivanliao/todo-app
5. run
   1. example ... docker run --name de_db_postgres -e POSTRES_PASSWORD=secret -d postgres