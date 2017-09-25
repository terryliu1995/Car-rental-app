# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create(email: 'root@ncsu', name: 'root', password: 'root', issuper: 2)
Customer.create(email: 'a@b.c', name: 'a', password: '1')
Customer.create(email: 'c@d.e', name: 'c', password: '1')