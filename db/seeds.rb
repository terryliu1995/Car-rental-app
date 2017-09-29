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

Car.create(manufacturer: 'Honda', model: 'Civic', style: 'Seden', location: 'Raleigh',
           hourlyRentalRate: '20.0', licencePlateNum: 'NC0001', status: 0)
Car.create(manufacturer: 'Honda', model: 'Accord', style: 'Seden', location: 'Raleigh',
           hourlyRentalRate: '40.0', licencePlateNum: 'NC0002', status: 0)
Car.create(manufacturer: 'Jeep', model: 'Compass', style: 'SUV', location: 'Raleigh',
           hourlyRentalRate: '55.0', licencePlateNum: 'NC0008', status: 0)
Car.create(manufacturer: 'Toyota', model: 'Camry', style: 'Seden', location: 'Cary',
           hourlyRentalRate: '30.0', licencePlateNum: 'NC0003', status: 0)
Car.create(manufacturer: 'Toyota', model: 'Rav4', style: 'SUV', location: 'Durham',
           hourlyRentalRate: '50.0', licencePlateNum: 'NC0004', status: 0)
Car.create(manufacturer: 'Ford', model: 'Focus', style: 'Coupe', location: 'Chapel Hill',
           hourlyRentalRate: '30.0', licencePlateNum: 'NC0005', status: 0)
Car.create(manufacturer: 'Ford', model: 'Escape', style: 'SUV', location: 'Chapel Hill',
           hourlyRentalRate: '50.0', licencePlateNum: 'NC0006', status: 0)
Car.create(manufacturer: 'BMW', model: 'X5', style: 'SUV', location: 'Raleigh',
           hourlyRentalRate: '100.0', licencePlateNum: 'NC0007', status: 0)
Car.create(manufacturer: 'Cherry', model: 'QQ', style: 'Coupe', location: 'Beijing',
           hourlyRentalRate: '10000.0', licencePlateNum: 'BJ0001', status: 0)