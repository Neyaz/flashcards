default["flashcards"]["ruby_version"]           = "2.2.3"

default["flashcards"]["database"]["name"]       = "#{node["flashcards"]["name"]}_#{node["flashcards"]["environment"]}"
default["flashcards"]["database"]["user"]       = "postgres"
default["flashcards"]["database"]["host"]       = "localhost"
default["flashcards"]["database"]["port"]       = 5432
